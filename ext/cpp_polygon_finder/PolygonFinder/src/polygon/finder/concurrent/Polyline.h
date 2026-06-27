/*
 * Polyline.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <list>
#include <cstdint>
#include <optional>
#include <utility>
#include <vector>
#include <unordered_map>
#include <string>
#include "Partitionable.h"
#include "Sequence.h"
#include "../RectBounds.h"
#include "../Primitives.h"

class Tile;
class Shape;
class ShapePool;
class Point;
class InnerPolyline;

class Polyline : public Partitionable {
 public:
  using Partitionable::Partitionable;
  Polyline(ShapePool* shape_pool, Tile* tile, std::vector<Point> polygon, const std::optional<RectBounds>& bounds = std::nullopt);
  enum Flags : uint32_t {
    TRACKED_OUTER = 1 << 0
  };
  void turn_on(Flags f) { flags_ |= f; }
  void turn_off(Flags f) { flags_ &= ~f; }
  bool is_on(Flags f) const { return(flags_ & f); }
  bool boundary();
  void precalc();
  int width();
  Tile *tile = nullptr;
  ShapePool* shape_pool = nullptr;
  Shape* shape = nullptr;
  const std::vector<Point>& raw() const { return raw_; }
  const std::vector<Part*>& parts() const { return parts_; }
  int max_y() const { return max_y_; }
  int min_y() const { return min_y_; }
  int max_x() const { return max_x_; }
  void clear();
  bool is_empty();
  bool any_ancients = false;
  bool vert_bounds_intersect(Bounds& vertical_bounds);
  bool within(std::vector<Point>& points);
  InnerPolyline* inside_inner_polyline = nullptr;
  std::string named();
  void set_named(std::string force_named) { this->named_ = force_named; }
  void fill_bounds(RectBounds& target_bounds) const;

 private:
  std::vector<Point> raw_;
  int min_x, max_x_, min_y_, max_y_;
  void find_boundary();
  uint32_t flags_ = 0;
  int name;
  std::string named_;
};
