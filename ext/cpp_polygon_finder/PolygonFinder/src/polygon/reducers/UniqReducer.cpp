/*
 * UniqReducer.cpp
 *
 *  Created on: 19 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
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
