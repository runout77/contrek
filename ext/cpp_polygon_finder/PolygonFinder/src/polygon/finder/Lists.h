/*
 * Lists.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
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
