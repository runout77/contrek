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

class Shape;
class Tile;
class Polyline;
class InnerPolyline;
class ShapePool {
 private:
  std::deque<Shape> shapes_storage;
  std::deque<InnerPolyline> inner_polylines_storage;
  std::deque<Sequence> sequences_storage;
  std::deque<Polyline> polylines_storage;

 public:
  Shape* acquire_shape(Polyline* outer_polyline, const std::vector<InnerPolyline*>& inner_polylines);
  InnerPolyline* acquire_inner_polyline(std::vector<Point*> coords, Shape* s, bool rec);
  InnerPolyline* acquire_inner_polyline(Sequence* seq);
  Sequence* acquire_sequence();
  Polyline* acquire_polyline(Tile* tile, const std::vector<Point*>& polygon, const std::optional<RectBounds>& bounds);
};
