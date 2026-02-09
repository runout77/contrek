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
#include "Finder.h"
#include "../../bitmaps/Bitmap.h"
#include "../../matchers/Matcher.h"
#include "../../matchers/RGBMatcher.h"
#include "../optionparser.h"
#include "../FinderUtils.h"
#include "ClippedPolygonFinder.h"
#include "Tile.h"
#include "Queue.h"
#include "Cluster.h"
#include "FakeCluster.h"

Finder::Finder(int number_of_threads, Bitmap *bitmap, Matcher *matcher, std::vector<std::string> *options)
: Poolable(number_of_threads),
  bitmap(bitmap),
  matcher(matcher),
  input_options(*options),
  maximum_width_(bitmap->w())
{ cpu_timer.start();
  if (options != nullptr) FinderUtils::sanitize_options(this->options, options);

  double cw = static_cast<double>(this->maximum_width_) / this->options.number_of_tiles;
  if (cw < 1.0) {
    throw std::runtime_error("One pixel tile width minimum!");
  }
  int x = 0;
  for (int tile_index = 0; tile_index < this->options.number_of_tiles; tile_index++)
  { int tile_end_x = static_cast<int>(cw * (tile_index + 1));
    TilePayload p { tile_index, x, tile_end_x };
    enqueue(p, [this](const TilePayload& payload) {
      std::vector<std::string> base_arguments = {"--bounds", "--versus=" + this->options.get_alpha_versus()};
      CpuTimer t;
      t.start();
      auto* finder = new ClippedPolygonFinder(
        this->bitmap,
        this->matcher,
        payload.tile_start_x,
        payload.tile_end_x,
        &base_arguments);
      {
        std::lock_guard<std::mutex> lock(finders_mutex);
        finders.push(finder);
      }

      Tile* tile = new Tile(this, payload.tile_start_x, payload.tile_end_x,
                            std::to_string(payload.tile_index), Benchmarks {0, 0});
      tile->initial_process(finder);
      tiles.queue_push(tile);
    });

    x = tile_end_x - 1;
  }
  this->process_tiles();
  reports["init"] = cpu_timer.stop();
}


void Finder::process_tiles() {
  std::vector<Tile*> arriving_tiles;

  while (true) {
    Tile* tile = tiles.queue_pop();

    if (tile->whole()) {
      this->whole_tile = tile;
      break;
    }

    auto it = std::find_if(
      arriving_tiles.begin(),
      arriving_tiles.end(),
      [&](Tile* t) {
        return (t->start_x() == (tile->end_x() - 1)) || ((t->end_x() - 1) == tile->start_x());
      });

    if (it != arriving_tiles.end()) {
      Tile* twin_tile = *it;
      int start_x, end_x;
      if (twin_tile->start_x() == (tile->end_x() - 1)) {
        start_x = tile->start_x();
        end_x = twin_tile->end_x();
      } else {
        start_x = twin_tile->start_x();
        end_x = tile->end_x();
      }

      Cluster *cluster = new Cluster(this, this->bitmap->h(), start_x, end_x);

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
        tiles.queue_push(merged_tile);
        delete c;
      });
    } else {
      arriving_tiles.push_back(tile);
    }
  }
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
  FakeCluster fake_cluster(pr->polygons, this->options);
  cpu_timer.start();
  fake_cluster.compress_coords(pr->polygons, this->options);
  reports["compress"] = cpu_timer.stop();
  reports["total"] = reports["compress"] + reports["init"];
  reports["outer"] = this->whole_tile->benchmarks.outer;
  reports["inner"] = this->whole_tile->benchmarks.inner;
  pr->benchmarks = this->reports;
  // TODO(ema): pr->treemap
  // TODO(ema): pr->named_sequence
  return(pr);
}
