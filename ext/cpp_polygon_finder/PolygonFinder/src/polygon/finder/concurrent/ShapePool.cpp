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
#include <iostream>
#include "Shape.h"
#include "ShapePool.h"
#include "Tile.h"

Shape* ShapePool::acquire_shape(Polyline* outer_polyline, const std::vector<InnerPolyline*>& inner_polylines) {
  Shape* shape = this->shapes.acquire(this, outer_polyline, inner_polylines);
  return shape;
}

Polyline* ShapePool::acquire_polyline(Tile* tile, std::vector<Point> polygon, const std::optional<RectBounds>& bounds = std::nullopt) {
  return this->polylines.acquire(this, tile, std::move(polygon), bounds);
}

InnerPolyline* ShapePool::acquire_inner_polyline(std::vector<Point> coords, Shape* shape) {
  return this->inner_polylines.acquire(this, std::move(coords), shape);
}

InnerPolyline* ShapePool::acquire_inner_polyline(Sequence* seq) {
  return this->inner_polylines.acquire(this, seq);
}

void ShapePool::set_owner(Tile* tile) {
  this->owner_tile_ = tile;
}

void ShapePool::detach_shape() {
  this->shapes.decrement();
  this->check_destruction();
}

void ShapePool::detach_polyline() {
  this->polylines.decrement();
  this->check_destruction();
}

void ShapePool::detach_inner_polyline() {
  this->inner_polylines.decrement();
  this->check_destruction();
}

void ShapePool::check_destruction() {
  if (this->shapes.is_released() &&
      this->polylines.is_released() &&
      this->inner_polylines.is_released()) {
    if (this->owner_tile_) {
      this->owner_tile_->unregister_pool(this);
    }
    delete this;
  }
}
