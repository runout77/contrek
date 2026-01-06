/*
 * Reducer.h
 *
 *  Created on: 16 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <list>
#include <vector>
#include "../finder/Node.h"

struct Point;
class Reducer {
 public:
  explicit Reducer(std::vector<Point*>& list_of_points);
  virtual void reduce();
 protected:
  std::vector<Point*> &points;
};
