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
#include "../RectBounds.h"

class Tile;
class Shape;
class Point;

class Polyline : public Partitionable {
 public:
  using Partitionable::Partitionable;
  Polyline(Tile* tile, const std::vector<Point*>& polygon, const std::optional<RectBounds>& bounds = std::nullopt);
  enum Flags : uint32_t {
    TRACKED_OUTER = 1 << 0,
    TRACKED_INNER = 1 << 1
  };
  void turn_on(Flags f) { flags_ |= f; }
  void turn_off(Flags f) { flags_ &= ~f; }
  bool is_on(Flags f) const { return(flags_ & f); }
  bool boundary();
  void precalc();
  int width();
  Tile *tile = nullptr;
  Shape* shape = nullptr;
  std::vector<Point*> raw() const { return raw_; }
  const std::list<Shape*>& next_tile_eligible_shapes() const { return next_tile_eligible_shapes_; }
  const std::vector<Part*>& parts() const { return parts_; }
  std::vector<std::pair<int, int>> intersection(const Polyline* other) const;
  const int max_y() const { return max_y_; }
  void clear();
  bool is_empty();
  bool vert_intersect(Polyline& other);
  void reset_tracked_endpoints();
  bool mixed_tile_origin = false;
  std::string info();

 private:
  std::vector<Point*> raw_;
  int min_x, max_x, min_y, max_y_;
  void find_boundary();
  uint32_t flags_ = 0;
  std::list<Shape*> next_tile_eligible_shapes_;
  mutable std::unordered_map<const EndPoint*, int> tracked_endpoints;
};
