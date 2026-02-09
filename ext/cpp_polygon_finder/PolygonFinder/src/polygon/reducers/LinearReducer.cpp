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

LinearReducer::LinearReducer(std::vector<Point*> &list_of_points)
: Reducer(list_of_points) {
}

void LinearReducer::reduce() {
  if (points.size() < 2) return;

  Point* start_p = points[0];
  Point* end_p = points[1];
  auto dir = seq_dir(start_p, end_p);

  for (size_t i = 2; i < points.size(); ++i) {
    Point* point = points[i];
    auto act_seq = seq_dir(end_p, point);
    if (act_seq == dir) {
      auto it = std::find_if(points.begin(), points.end(), [&](Point* p) {  // TODO(ema): optimize...
        return p->x == end_p->x && p->y == end_p->y;
      });
      if (it != points.end()) {
        size_t removed_idx = std::distance(points.begin(), it);
        points.erase(it);
        if (removed_idx <= i) i--;
      }
    } else {
      dir = act_seq;
    }
    end_p = point;
  }
}

std::array<int, 2> LinearReducer::seq_dir(Point *a, Point *b)
{ return { b->x - a->x, b->y - a->y };
}
