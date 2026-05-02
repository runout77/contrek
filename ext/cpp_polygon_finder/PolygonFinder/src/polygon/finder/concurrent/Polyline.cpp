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
#include <string>
#include <unordered_set>
#include <sstream>
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

void Polyline::clear() {
  this->raw_.clear();
}

bool Polyline::is_empty() {
  return raw_.empty();
}

std::string Polyline::info() {
  Shape* shape = this->shape;
  size_t part_index = 0;
  auto it = std::find(this->tile->shapes().begin(), this->tile->shapes().end(), shape);
  if (it != this->tile->shapes().end()) {
    part_index = std::distance(this->tile->shapes().begin(), it);
  }
  std::stringstream ss;
  ss << "b" << this->tile->name() << " S" << part_index;
  return ss.str();
}

bool Polyline::vert_bounds_intersect(Bounds& vertical_bounds)
{ return !(this->max_y_ < vertical_bounds.min || vertical_bounds.max < this->min_y);
}

bool Polyline::within(std::vector<Point*>& points) {
  size_t n = points.size();
  if (n < 3) return false;
  const int tx = this->raw_[0]->x;
  const int ty = this->raw_[0]->y;
  bool inside = false;
  for (size_t i = 0, j = n - 1; i < n; j = i++) {
    const Point* pi = points[i];
    const Point* pj = points[j];
    if (((pi->y > ty) != (pj->y > ty)) &&
        (tx < (pj->x - pi->x) * (ty - pi->y) / (pj->y - pi->y) + pi->x)) {
      inside = !inside;
    }
  }
  return inside;
}
