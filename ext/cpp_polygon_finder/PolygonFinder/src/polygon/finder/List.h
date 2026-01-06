/*
 * List.h
 *
 *  Created on: 08 gen 2019
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once

#include <vector>
#include "Lists.h"
struct Link;
class Listable {
 public:
  std::vector<Link> data_pointer;
};

class List {
 public:
  explicit List(int id);
  void push_back(Listable *entry);
  void remove(Listable *entry);
  void grab(List *source_list);
  int size();
  Listable *first();
  Listable *last();
  Listable *shift();
  void reset();
  bool contains(Listable *entry);
  int get_id();
 private:
  Listable  *start;
  Listable  *end;
  int   isize;
  int   idd;
};
