/*
 * Polygon.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
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
