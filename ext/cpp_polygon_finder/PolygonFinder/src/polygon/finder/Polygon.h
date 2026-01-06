/*
 * Polygon.h
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <vector>
#include <list>
#include "Node.h"
#include "RectBounds.h"

struct Polygon {
  std::vector<Point*> outer;
  std::list<std::vector<Point*>> inner;
  RectBounds bounds;
  Polygon() : bounds(RectBounds::empty()) {}
};
