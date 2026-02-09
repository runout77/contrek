/*
 * List.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
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
