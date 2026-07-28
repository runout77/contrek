/*
 * LinearReducer.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <iterator>
#include <list>
#include <iostream>
#include <algorithm>
#include "LinearReducer.h"
#include "Reducer.h"

LinearReducer::LinearReducer(std::vector<Point>& list_of_points)
: Reducer(list_of_points) {
}

void LinearReducer::reduce() {
  if (points.size() < 3) return;

  size_t write_idx = 1;
  for (size_t i = 2; i < points.size(); ++i) {
    const Point& start_p = points[write_idx - 1];
    const Point& end_p   = points[write_idx];
    const Point& curr_p  = points[i];

    int dx1 = end_p.x - start_p.x;
    int dy1 = end_p.y - start_p.y;

    int dx2 = curr_p.x - end_p.x;
    int dy2 = curr_p.y - end_p.y;

    int sx1 = (0 < dx1) - (dx1 < 0);
    int sy1 = (0 < dy1) - (dy1 < 0);

    int sx2 = (0 < dx2) - (dx2 < 0);
    int sy2 = (0 < dy2) - (dy2 < 0);

    if (sx1 == sx2 && sy1 == sy2) {
      points[write_idx] = curr_p;
    } else {
      write_idx++;
      points[write_idx] = curr_p;
    }
  }
  points.resize(write_idx + 1);
}
