/*
 * Shape.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <list>
#include "Shape.h"
#include "Polyline.h"

Shape::Shape(Polyline* outer_polyline, const std::list<std::vector<Point*>>& inner_polylines)
: outer_polyline(outer_polyline),
  inner_polylines(inner_polylines) {
}

Shape::~Shape() {
  if (outer_polyline) {
    delete outer_polyline;
  }
}

void Shape::clear_inner() {
  inner_polylines.clear();
}
