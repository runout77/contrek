/*
 * ShapePool.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <vector>
#include <utility>
#include "Shape.h"
#include "ShapePool.h"
#include "Tile.h"

Shape* ShapePool::acquire_shape(Polyline* outer_polyline, const std::vector<InnerPolyline*>& inner_polylines) {
  shapes_storage.emplace_back(this, outer_polyline, inner_polylines);
  Shape* shape = &shapes_storage.back();
  this->shapes_count++;
  return shape;
}

void ShapePool::set_owner(Tile* tile) {
  this->owner_tile_ = tile;
}

void ShapePool::detach_shape() {
  this->shapes_count--;
  if (this->shapes_count == 0) {
    this->owner_tile_->unregister_pool(this);
    delete this;
  }
}

InnerPolyline* ShapePool::acquire_inner_polyline(std::vector<Point> coords, Shape* shape) {
  inner_polylines_storage.emplace_back(std::move(coords), shape);
  InnerPolyline* ip = &inner_polylines_storage.back();
  return ip;
}

InnerPolyline* ShapePool::acquire_inner_polyline(Sequence* seq) {
  inner_polylines_storage.emplace_back(seq);
  InnerPolyline* ip = &inner_polylines_storage.back();
  return ip;
}

Sequence* ShapePool::acquire_sequence() {
  sequences_storage.emplace_back();
  Sequence* s = &sequences_storage.back();
  return s;
}

Polyline* ShapePool::acquire_polyline(Tile* tile, std::vector<Point> polygon, const std::optional<RectBounds>& bounds = std::nullopt) {
  polylines_storage.emplace_back(tile, std::move(polygon), bounds);
  Polyline* p = &polylines_storage.back();
  return p;
}
