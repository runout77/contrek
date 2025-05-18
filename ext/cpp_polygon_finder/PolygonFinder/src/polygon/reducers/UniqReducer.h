/*
 * UniqReducer.h
 *
 *  Created on: 19 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#ifndef POLYGON_REDUCERS_UNIQREDUCER_H_
#define POLYGON_REDUCERS_UNIQREDUCER_H_

#include "Reducer.h"

class UniqReducer : public Reducer {
 public:
  UniqReducer(std::list<Point*> *list_of_points);
  virtual ~UniqReducer();
  void reduce();
};

#endif /* POLYGON_REDUCERS_UNIQREDUCER_H_ */
