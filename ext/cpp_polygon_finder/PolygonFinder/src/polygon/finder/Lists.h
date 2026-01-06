/*
 * Lists.h
 *
 *  Created on: 08 gen 2019
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <list>
#include <vector>
#include "List.h"
class List;
class Listable;
struct Link {
  Listable *next, *prev;
  bool inside;
};

class Lists {
 public:
  Lists() {}
  virtual ~Lists();
  List *add_list();
  std::vector<Link> get_data_pointer();
 private:
  std::list<List*> lists;
};
