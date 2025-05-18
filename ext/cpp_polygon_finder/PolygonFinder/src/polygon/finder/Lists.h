/*
 * Lists.h
 *
 *  Created on: 08 gen 2019
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#ifndef POLYGON_FINDER_LISTS_H_
#define POLYGON_FINDER_LISTS_H_
#include <list>
#include "List.h"
class List;
class Listable;
struct Link {
  Listable *next, *prev;
  bool inside;
};

class Lists {
 public:
  Lists();
  virtual ~Lists();
  List *add_list();
  Link *get_data_pointer();
 private:
  std::list<List*> *lists;
};

#endif /* POLYGON_FINDER_LISTS_H_ */
