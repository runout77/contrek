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
#include <vector>
struct Link;
class List;

Lists::~Lists() {
  for (auto* list : this->lists)
  { delete list;
  }
}

List *Lists::add_list() {
  List *list = new List(this->lists.size());
  lists.push_back(list);
  return(list);
}

std::vector<Link> Lists::get_data_pointer() {
  std::vector<Link> data(this->lists.size());
  for (auto& dt : data) {
    dt.inside = false;
    dt.next = nullptr;
    dt.prev = nullptr;
  }
  return data;
}
