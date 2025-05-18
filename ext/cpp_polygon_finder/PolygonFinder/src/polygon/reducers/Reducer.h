/*
 * Reducer.h
 *
 *  Created on: 16 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#ifndef POLYGON_REDUCERS_REDUCER_H_
#define POLYGON_REDUCERS_REDUCER_H_

#include <list>
#include "../finder/Node.h"

struct Point;
class Reducer {
 public:
  Reducer(std::list<Point*> *list_of_points);
  virtual ~Reducer();
  virtual void reduce();
 protected:
  std::list<Point*> *points;
};

#endif /* POLYGON_REDUCERS_REDUCER_H_ */
