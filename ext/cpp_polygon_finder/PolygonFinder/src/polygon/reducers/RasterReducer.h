/*
 * RasterReducer.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <vector>
#include "Reducer.h"

struct Point;

class RasterReducer : public Reducer {
 public:
  RasterReducer(std::vector<Point>& points, int versus);
  void reduce() override;

 private:
  enum class Pole {
    North,
    South,
    East,
    West
  };
  int versus_;
  void toRasterPolygon(std::vector<Point>& points, int versus);
  static Pole segmentPole(int dx, int dy, bool clockwise);
  static int sign(int value);
};
