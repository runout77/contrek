/*
 * Shape.h
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
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
