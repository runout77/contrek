/*
 * Finder.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <utility>
#include <vector>
#include <string>
#include <algorithm>
#include "Finder.h"
#include "../../bitmaps/Bitmap.h"
#include "../../matchers/Matcher.h"
#include "../../matchers/RGBMatcher.h"
#include "../FinderUtils.h"
#include "ClippedPolygonFinder.h"
#include "Tile.h"
#include "Queue.h"
#include "Cluster.h"
#include "FakeCluster.h"

Finder::Finder(int number_of_threads, Bitmap *bitmap, Matcher *matcher, const Options& options)
: Poolable(number_of_threads),
  bitmap(bitmap),
  matcher(matcher),
  input_options(options),
  maximum_width_(bitmap->w()),
  height(bitmap->h())
{ cpu_timer.start();
  FinderUtils::sanitize_options(this->options_, options);

  double cw = static_cast<double>(this->maximum_width_) / this->options_.number_of_tiles;
  if (cw < 1.0) {
    throw std::runtime_error("One pixel tile width minimum!");
  }
  if (this->options_.deterministic && (this->options_.number_of_tiles % 2 != 0)) {
    throw std::invalid_argument("Deterministic mode requires an even number of tiles!");
  }
  int x = 0;
  for (int tile_index = 0; tile_index < this->options_.number_of_tiles; tile_index++)
  { int tile_end_x = static_cast<int>(cw * (tile_index + 1));
    TilePayload p { tile_index, x, tile_end_x };
    enqueue(p, [this](const TilePayload& payload) {
      Options base_arguments = {
        {"bounds", true},
        {"versus", Identifier{this->options_.get_alpha_versus()}},
      };
      if (this->options_.connectivity_offset == 1) {
        base_arguments["connectivity"] = 8;
      }
      if (this->options_.treemap) {
        base_arguments["treemap"] = true;
      }

      CpuTimer t;
      t.start();
      auto* finder = new ClippedPolygonFinder(
        this->bitmap,
        this->matcher,
        payload.tile_start_x,
        payload.tile_end_x,
        base_arguments);
      {
        std::lock_guard<std::mutex> lock(finders_mutex);
        finders.push(finder);
      }

      Tile* tile = new Tile(this, payload.tile_start_x, payload.tile_end_x,
                            std::to_string(payload.tile_index), payload.tile_index, Benchmarks {0, 0});
      tile->initial_process(finder);
      tiles_.queue_push(tile);
    });

    x = tile_end_x - 1;
  }
  this->process_tiles(this->options_.deterministic);
  reports["init"] = cpu_timer.stop();
}

Finder::Finder(int number_of_threads, const Options& options)
: Poolable(number_of_threads), bitmap(nullptr), matcher(nullptr), input_options(options), maximum_width_(0) {
  FinderUtils::sanitize_options(this->options_, options);
  reports["init"] = 0;
}

void Finder::process_tiles(bool deterministic) {
  std::vector<Tile*> arriving_tiles;

  while (true) {
    Tile* tile = tiles_.queue_pop();

    if (tile->whole()) {
      this->whole_tile = tile;
      break;
    }

    auto it = std::find_if(
      arriving_tiles.begin(),
      arriving_tiles.end(),
      [&](Tile* t) {
        bool is_adjacent = (t->start_x() == (tile->end_x() - 1)) ||
                           ((t->end_x() - 1) == tile->start_x());
        if (!is_adjacent) return false;
        if (deterministic && !this->last_couple(tile, t)) {
          if (tile->order() != t->order()) return false;
          if (std::min(t->index(), tile->index()) % 2 != 0) return false;
        }
        return true;
      });

    if (it != arriving_tiles.end()) {
      Tile* twin_tile = *it;

      Cluster *cluster = new Cluster(this, this->height);

      if (twin_tile->start_x() == (tile->end_x() - 1)) {
        cluster->add(tile);
        cluster->add(twin_tile);
      } else {
        cluster->add(twin_tile);
        cluster->add(tile);
      }
      arriving_tiles.erase(it);
      enqueue(cluster, [this](Cluster* c) {
        Tile* merged_tile = c->merge_tiles();
        tiles_.queue_push(merged_tile);
        delete c;
      });
    } else {
      arriving_tiles.push_back(tile);
    }
  }
}

bool Finder::last_couple(const Tile* tile_a, const Tile* tile_b) const {
  bool a_is_first = tile_a->index() < tile_b->index();
  const Tile* first = a_is_first ? tile_a : tile_b;
  const Tile* last  = a_is_first ? tile_b : tile_a;
  return (first->start_x() == 0) && (last->end_x() == this->maximum_width());
}

Finder::~Finder() {
  if (this->whole_tile) {
    delete this->whole_tile;  // last tile to be deleted (not owned by a cluster)
  }

  while (!finders.empty()) {
    ClippedPolygonFinder* finder = nullptr;
    { std::lock_guard<std::mutex> lock(finders_mutex);
      finder = finders.front();
      finders.pop();
    }
    delete finder;
  }
}

ProcessResult* Finder::process_info() {
  ProcessResult *pr = new ProcessResult();
  pr->polygons = std::move(this->whole_tile->to_raw_polygons());
  pr->groups = pr->polygons.size();
  pr->width = this->maximum_width_;
  pr->height = this->height;
  pr->has_bounds = this->options_.bounds;
  pr->versus = this->options_.versus;
  pr->options = this->input_options;
  FakeCluster fake_cluster(pr->polygons, this->options_);
  cpu_timer.start();
  fake_cluster.compress_coords(pr->polygons, this->options_);
  reports["compress"] = cpu_timer.stop();
  reports["total"] = reports["compress"] + reports["init"];
  reports["outer"] = this->whole_tile->benchmarks.outer;
  reports["inner"] = this->whole_tile->benchmarks.inner;
  if (this->options_.treemap) {
    pr->treemap = this->whole_tile->compute_treemap();
  }
  pr->benchmarks = this->reports;
  // TODO(ema): pr->named_sequence
  return(pr);
}
