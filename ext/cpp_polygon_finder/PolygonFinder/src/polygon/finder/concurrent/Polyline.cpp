/*
 * Polyline.cpp
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
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

struct PointHash {
  size_t operator()(const Point* p) const {
    if (!p) return 0;
    std::hash<double> hasher;
    size_t h1 = hasher(p->x);
    size_t h2 = hasher(p->y);
    return h1 ^ (h2 << 1);
  }
};

struct PointEqual {
  bool operator()(const Point* p1, const Point* p2) const {
    if (!p1 || !p2) return p1 == p2;
    return *p1 == *p2;
  }
};

std::vector<Point*> Polyline::intersection(const Polyline* other) const {
  std::vector<Point*> result;
  if (!other) return result;
  std::unordered_set<Point*, PointHash, PointEqual> other_set;
  other_set.reserve(other->raw().size());
  for (Point* p : other->raw()) {
    if (p) other_set.insert(p);
  }
  for (Point* p : raw_) {
    if (!p) continue;
    if (other_set.count(p)) {
      result.push_back(p);
    }
  }
  return result;
}

void Polyline::clear() {
  this->raw_.clear();
}

bool Polyline::is_empty() {
  return raw_.empty();
}
