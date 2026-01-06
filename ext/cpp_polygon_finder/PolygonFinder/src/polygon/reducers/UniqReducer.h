/*
 * UniqReducer.h
 *
 *  Created on: 19 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <vector>
#include "Reducer.h"

class UniqReducer : public Reducer {
 public:
  explicit UniqReducer(std::vector<Point*>& list_of_points);
  void reduce();
};
