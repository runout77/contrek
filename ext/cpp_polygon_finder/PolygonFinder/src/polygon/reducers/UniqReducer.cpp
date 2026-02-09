/*
 * UniqReducer.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <vector>
#include <algorithm>
#include <iostream>
#include "UniqReducer.h"
#include "Reducer.h"

UniqReducer::UniqReducer(std::vector<Point*>& list_of_points) : Reducer(list_of_points) {
}

struct is_near {
  bool operator() (Point* first, Point* second) const {
    return first->x == second->x && first->y == second->y;
  }
};

void UniqReducer::reduce() {
  auto last = std::unique(points.begin(), points.end(), is_near());
  points.erase(last, points.end());
}
