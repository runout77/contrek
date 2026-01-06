/*
 * Polyline.h
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <list>
#include <cstdint>
#include <optional>
#include <vector>
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
  std::vector<Point*> intersection(const Polyline* other) const;
  const int max_y() const { return max_y_; }
  void clear();
  bool is_empty();
  bool vert_intersect(Polyline& other);

 private:
  std::vector<Point*> raw_;
  int min_x, max_x, min_y, max_y_;
  void find_boundary();
  uint32_t flags_ = 0;
  std::list<Shape*> next_tile_eligible_shapes_;
};
