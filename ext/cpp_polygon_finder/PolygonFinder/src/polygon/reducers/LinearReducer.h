/*
 * LinearReducer.h
 *
 *  Created on: 19 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#ifndef POLYGON_REDUCERS_LINEARREDUCER_H_
#define POLYGON_REDUCERS_LINEARREDUCER_H_

#include "Reducer.h"

class LinearReducer : public Reducer {
 public:
  LinearReducer(std::list<Point*> *list_of_points);
  virtual ~LinearReducer();
  void reduce();
 private:
  int *seq_dir(Point *a, Point *b);
};

#endif /* POLYGON_REDUCERS_LINEARREDUCER_H_ */
