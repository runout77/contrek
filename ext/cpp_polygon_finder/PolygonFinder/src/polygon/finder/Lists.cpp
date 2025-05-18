/*
 * Lists.cpp
 *
 *  Created on: 08 gen 2019
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include "Lists.h"
#include "List.h"
#include <list>
struct Link;
class List;
Lists::Lists() {
  this->lists = new std::list<List*>();
}

Lists::~Lists() {
}

List *Lists::add_list() {
  List *list = new List(this->lists->size());
  lists->push_back(list);
  return(list);
}

Link *Lists::get_data_pointer() {
  Link *data_pointer = new Link[this->lists->size()];
  Link *dt = data_pointer;
  for (unsigned int i = 0; i < this->lists->size(); ++i, dt++)
  { dt->inside = false;
    dt->next = nullptr;
    dt->prev = nullptr;
  }
  return(data_pointer);
}
