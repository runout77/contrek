/*
 * Lists.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
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
