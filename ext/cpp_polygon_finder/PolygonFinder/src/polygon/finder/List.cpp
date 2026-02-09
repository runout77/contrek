/*
 * List.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "List.h"
#include <iostream>

class Listable;

List::List(int id) {
  this->start = nullptr;
  this->end = nullptr;
  this->isize = 0;
  this->idd = id;
}

Listable *List::first() {
  return(this->start);
}
Listable *List::last() {
  return(this->end);
}

bool List::contains(Listable *entry) {
  return(entry->data_pointer[this->idd].inside);
}
int List::get_id() {
  return(this->idd);
}

void List::grab(List *source_list) {
  if (source_list->size() == 0) return;
  int source_list_idd = source_list->get_id();
  Listable *source_list_start_entry = source_list->first();

  Listable *act = source_list->last();
  while (true)
  { if ((act = act->data_pointer[source_list_idd].prev) == nullptr) break;
  }
  Listable *source_entry = source_list->first();
  while (true)
  { source_entry->data_pointer[this->idd] = source_entry->data_pointer[source_list_idd];
    Listable *next_entry = source_entry->data_pointer[source_list_idd].next;
    source_entry->data_pointer[source_list_idd].inside = false;
    source_entry->data_pointer[source_list_idd].next = nullptr;
    source_entry->data_pointer[source_list_idd].prev = nullptr;
    if (next_entry == nullptr) break;
    source_entry = next_entry;
  }
  source_list_start_entry->data_pointer[this->idd].prev = this->end;
  if (this->end != nullptr) this->end->data_pointer[this->idd].next = source_list_start_entry;
  this->end = source_list->last();
  if (this->start == nullptr) this->start = source_list->first();
  this->isize += source_list->size();
  source_list->reset();
}

void List::reset()  {
  this->end = nullptr;
  this->start = nullptr;
  this->isize = 0;
}

Listable *List::shift() {
  if (this->isize == 0) return(nullptr);
  Listable *retme = this->start;
  Listable *next_of_retme = retme->data_pointer[this->idd].next;
  this->start = next_of_retme;
  if (retme == this->end) this->end = nullptr;
  if (next_of_retme != nullptr) next_of_retme->data_pointer[this->idd].prev = nullptr;
  this->isize--;
  retme->data_pointer[this->idd].next = nullptr;
  retme->data_pointer[this->idd].prev = nullptr;
  retme->data_pointer[this->idd].inside = false;
  return (retme);
}

void List::push_back(Listable *entry) {
  if (entry->data_pointer[this->idd].inside) return;
  if (this->isize > 0)
  { this->end->data_pointer[this->idd].next = entry;
    entry->data_pointer[this->idd].prev = this->end;
  } else {
    this->start = entry;
  }
  this->end = entry;
  entry->data_pointer[this->idd].inside = true;
  this->isize++;
}
int List::size() {
  return(this->isize);
}

void List::remove(Listable *entry) {
  if (this->isize == 0) return;
  if (entry->data_pointer[this->idd].inside == false) return;
  Listable *next_of_entry = entry->data_pointer[this->idd].next;
  Listable *prev_of_entry = entry->data_pointer[this->idd].prev;

  if (entry == this->start)
  { this->start = next_of_entry;
  }
  if (entry == this->end)
  { this->end = prev_of_entry;
  }

  if (next_of_entry != nullptr)  next_of_entry->data_pointer[this->idd].prev = prev_of_entry;
  if (prev_of_entry != nullptr)  prev_of_entry->data_pointer[this->idd].next = next_of_entry;
  entry->data_pointer[this->idd].next = nullptr;
  entry->data_pointer[this->idd].prev = nullptr;
  this->isize--;
  entry->data_pointer[this->idd].inside = false;
}
