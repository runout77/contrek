/*
 * Shape.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <list>
#include <iostream>
#include <vector>

class Point;
class Polyline;
class Shape {
 public:
  Shape(Polyline* outer_polyline, const std::list<std::vector<Point*>>& inner_polylines);
  virtual ~Shape();
  Polyline* outer_polyline = nullptr;
  std::list<std::vector<Point*>> inner_polylines;
  void clear_inner();
};
