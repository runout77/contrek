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

List::List(int id) : start(nullptr), end(nullptr), isize(0), idd(id) {}

Listable *List::first() { return this->start; }
Listable *List::last() { return this->end; }
int List::get_id() { return this->idd; }
int List::size() { return this->isize; }

bool List::contains(Listable *entry) {
  return entry->data_pointer[this->idd].inside;
}

void List::reset() {
  this->end = nullptr;
  this->start = nullptr;
  this->isize = 0;
}

void List::push_back(Listable *entry) {
  auto& meta = entry->data_pointer[this->idd];
  if (meta.inside) return;

  if (this->isize > 0) {
    this->end->data_pointer[this->idd].next = entry;
    meta.prev = this->end;
  } else {
    this->start = entry;
    meta.prev = nullptr;
  }

  meta.next = nullptr;
  this->end = entry;
  meta.inside = true;
  this->isize++;
}

void List::remove(Listable *entry) {
  auto& meta = entry->data_pointer[this->idd];
  if (this->isize == 0 || !meta.inside) return;

  Listable *nxt = meta.next;
  Listable *prv = meta.prev;

  if (entry == this->start) this->start = nxt;
  if (entry == this->end)   this->end = prv;

  if (nxt) nxt->data_pointer[this->idd].prev = prv;
  if (prv) prv->data_pointer[this->idd].next = nxt;

  meta.next = nullptr;
  meta.prev = nullptr;
  meta.inside = false;
  this->isize--;
}

Listable *List::shift() {
  if (this->isize == 0) return nullptr;
  Listable *retme = this->start;
  auto& meta = retme->data_pointer[this->idd];

  this->start = meta.next;
  if (retme == this->end) this->end = nullptr;
  if (this->start) this->start->data_pointer[this->idd].prev = nullptr;

  this->isize--;
  meta.next = nullptr;
  meta.prev = nullptr;
  meta.inside = false;
  return retme;
}

void List::grab(List *source_list) {
  if (source_list->isize == 0) return;

  int src_idd = source_list->idd;
  Listable *current = source_list->start;

  while (current) {
    auto& src_meta = current->data_pointer[src_idd];
    auto& dst_meta = current->data_pointer[this->idd];
    dst_meta = src_meta;
    src_meta.inside = false;
    src_meta.next = nullptr;
    src_meta.prev = nullptr;
    current = dst_meta.next;
  }

  if (this->isize > 0) {
    this->end->data_pointer[this->idd].next = source_list->start;
    source_list->start->data_pointer[this->idd].prev = this->end;
    this->end = source_list->end;
  } else {
    this->start = source_list->start;
    this->end = source_list->end;
  }

  this->isize += source_list->isize;
  source_list->reset();
}
