/*
 * LinearReducer.h
 *
 *  Created on: 19 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <vector>
#include <array>
#include "Reducer.h"

class LinearReducer : public Reducer {
 public:
  explicit LinearReducer(std::vector<Point*>& list_of_points);
  void reduce();

 private:
  std::array<int, 2> seq_dir(Point *a, Point *b);
};
