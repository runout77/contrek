/*
 * ShapePool.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <deque>
#include <vector>
#include "Shape.h"
#include "../RectBounds.h"
#include "Polyline.h"
#include "SubPool.h"

class Shape;
class Tile;
class Polyline;
class InnerPolyline;
class ShapePool {
 private:
  Tile* owner_tile_ = nullptr;
  SubPool<Shape> shapes{this};
  SubPool<Polyline> polylines{this};
  SubPool<InnerPolyline> inner_polylines{this};
 public:
  Shape* acquire_shape(Polyline* outer_polyline, const std::vector<InnerPolyline*>& inner_polylines);
  InnerPolyline* acquire_inner_polyline(std::vector<Point> coords, Shape* s);
  InnerPolyline* acquire_inner_polyline(Sequence* seq);
  Polyline* acquire_polyline(Tile* tile, std::vector<Point> polygon, const std::optional<RectBounds>& bounds);
  void set_owner(Tile* tile);
  void detach_shape();
  void detach_polyline();
  void detach_inner_polyline();
  void check_destruction();
};
