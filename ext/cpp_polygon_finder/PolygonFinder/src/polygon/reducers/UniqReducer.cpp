/*
 * UniqReducer.cpp
 *
 *  Created on: 19 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include "UniqReducer.h"
#include "Reducer.h"
#include "algorithm"
#include "list"
#include "iterator"
#include "iostream"

UniqReducer::UniqReducer(std::list<Point*> *list_of_points) : Reducer(list_of_points) {
}

UniqReducer::~UniqReducer() {
}

struct is_near {
  bool operator() (Point *first, Point *second)
  { return (first->x == second->x && first->y == second->y); }
};

void UniqReducer::reduce() {
  this->points->unique(is_near());
}

