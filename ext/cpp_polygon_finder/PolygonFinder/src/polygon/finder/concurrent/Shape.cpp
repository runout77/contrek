/*
 * Shape.cpp
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
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
