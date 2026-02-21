/*
 * List.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <array>

// Forward declaration
class Listable;

// Definizione completa di Link (necessaria per std::array)
struct Link {
  Listable* next = nullptr;
  Listable* prev = nullptr;
  bool inside = false;
};

class Listable {
 public:
  std::array<Link, 3> data_pointer;
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
