/*
 * LinearReducer.cpp
 *
 *  Created on: 19 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include <iterator>
#include <list>
#include "LinearReducer.h"
#include "Reducer.h"

LinearReducer::LinearReducer(std::list<Point*> *list_of_points) : Reducer(list_of_points) {
}

LinearReducer::~LinearReducer() {
}

void LinearReducer::reduce() {
  std::list<Point*>::iterator start_p = this->points->begin();
  std::list<Point*>::iterator end_p = std::next(start_p, 1);

  int *dir = seq_dir(*start_p, *end_p);

  for (std::list<Point*>::iterator point = std::next(end_p, 1); point != this->points->end(); ++point)
  { int *act_seq = seq_dir(*end_p, *point);
    if (act_seq[0] == dir[0] && act_seq[1] == dir[1])
    { point = this->points->erase(end_p);
      end_p = point;
    } else {
      dir = act_seq;
      end_p = point;
    }
  }
}

int *LinearReducer::seq_dir(Point *a, Point *b)
{ return(new int[2] {b->x - a->x, b->y - a->y});
}
