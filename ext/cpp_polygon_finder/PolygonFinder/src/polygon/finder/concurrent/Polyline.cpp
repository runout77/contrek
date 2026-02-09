/*
 * Polyline.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <vector>
#include <limits>
#include <unordered_set>
#include "Polyline.h"
#include "Tile.h"
#include "Shape.h"

Polyline::Polyline(Tile* tile, const std::vector<Point*>& polygon, const std::optional<RectBounds>& bounds)
: raw_(polygon),
  tile(tile)
{ if (bounds.has_value()) {
    min_x =  bounds->min_x;
    max_x = bounds->max_x;
    min_y =  bounds->min_y;
    max_y_ = bounds->max_y;
  } else {
    this->find_boundary();  // TODO(ema): optimize when merging the bounds are the sum of the previouses
  }
}

void Polyline::precalc() {
  next_tile_eligible_shapes_.clear();  // useless if called once
  for (Shape* s : tile->circular_next->boundary_shapes())
  { if (!s->outer_polyline->is_on(Polyline::TRACKED_OUTER) && this->vert_intersect(*s->outer_polyline) )
    { next_tile_eligible_shapes_.push_back(s);
    }
  }
}

bool Polyline::vert_intersect(Polyline& other) {
  return( !(this->max_y_ < other.min_y || other.max_y_ < this->min_y));
}

int Polyline::width() {
  if (raw_.empty()) return 0;
  return(max_x - min_x);
}

bool Polyline::boundary() {
  return( tile->tg_border(Point{min_x, 0}) || tile->tg_border(Point{max_x, 0}));
}

void Polyline::reset_tracked_endpoints() {
  tracked_endpoints.clear();
}

void Polyline::find_boundary() {
  if (raw_.empty()) return;
  min_x =  std::numeric_limits<int>::max();
  max_x = -std::numeric_limits<int>::max();
  min_y =  std::numeric_limits<int>::max();
  max_y_ = -std::numeric_limits<int>::max();
  for (Point* p : raw_) {
    if (!p) continue;
    int x = p->x;
    int y = p->y;
    if (x < min_x) min_x = x;
    if (x > max_x) max_x = x;
    if (y < min_y) min_y = y;
    if (y > max_y_) max_y_ = y;
  }
}

std::vector<std::pair<int, int>> Polyline::intersection(const Polyline* other) const {
  if (this->tracked_endpoints.empty()) {
    for (int i = 0; i < parts_.size(); ++i) {
      auto& part = parts_[i];
      if (!part->is(Part::SEAM) && part->trasmuted) continue;
      part->each([&](QNode<Point>* pos) -> bool {
        Position *position = dynamic_cast<Position*>(pos);
        if (position->end_point() != nullptr)
        { this->tracked_endpoints[position->end_point()] = i;
        }
        return true;
      });
    }
  }

  std::vector<std::pair<int, int>> matching_parts;
  for (int j = 0; j < other->parts_.size(); ++j) {
    auto& other_part = other->parts_[j];
    if (!other_part->is(Part::SEAM) && other_part->trasmuted) {
      continue;
    }
    other_part->each([&](QNode<Point>* pos) -> bool {
      Position *position = dynamic_cast<Position*>(pos);
      auto it = this->tracked_endpoints.find(position->end_point());
      if (it != this->tracked_endpoints.end()) {
        int self_index = it->second;
        matching_parts.push_back({self_index, j});
        return false;
      }
      return true;
    });
  }

  return matching_parts;
}


void Polyline::clear() {
  this->raw_.clear();
}

bool Polyline::is_empty() {
  return raw_.empty();
}
