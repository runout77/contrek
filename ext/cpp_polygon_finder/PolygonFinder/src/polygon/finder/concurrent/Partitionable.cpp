/*
 * Partitionable.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <vector>
#include <utility>
#include <iostream>
#include <algorithm>
#include "Partitionable.h"
#include "Polyline.h"
#include "Sequence.h"
#include "Tile.h"
#include "../Node.h"
#include "PartPool.h"
#include "Cluster.h"

class Polyline;
class Point;
class Tile;

void Partitionable::add_part(Part* new_part)
{ Part* last = this->parts_.empty() ? nullptr : this->parts_.back();
  this->parts_.push_back(new_part);
  if (last) {
    last->next = last->circular_next = new_part;
  }
  new_part->prev = last;
  new_part->circular_next = this->parts_.front();

  if (new_part->is(Part::SEAM)) {
    if (!this->first_seam) {
      this->first_seam = new_part;
    }
    if (this->last_seam) {
      this->last_seam->next_seam = new_part;
    }
    this->last_seam = new_part;
    new_part->orient();
  }
}

void Partitionable::partition()
{ this->parts_.clear();
  this->first_seam = nullptr;
  this->last_seam = nullptr;

  Polyline *polyline = static_cast<Polyline*>(this);
  PartPool& pool = polyline->tile->cluster->parts_pool;
  Part *current_part = nullptr;
  int n = 0;
  const Point* prev_position = nullptr;
  for (const Point& position : polyline->raw())
  { if (polyline->tile->tg_border(position))
    { if (current_part == nullptr) {
        current_part = pool.acquire(Part::SEAM, polyline);
      } else if (!current_part->is(Part::SEAM)) {
        this->add_part(current_part);
        current_part = pool.acquire(Part::SEAM, polyline);
      }
    } else if (current_part == nullptr) {
      current_part = pool.acquire(Part::EXCLUSIVE, polyline);
    } else if (!current_part->is(Part::EXCLUSIVE)) {
      this->add_part(current_part);
      current_part = pool.acquire(Part::EXCLUSIVE, polyline);
    }
    if (n > 0 && *prev_position == position) {
      current_part->inverts = true;
    }
    current_part->add_position(position);
    n++;
    prev_position = &position;
  }
  this->add_part(current_part);

  this->transmute_parts();
}

void Partitionable::transmute_transposed_part(Part* part) {
  if (Part* current_seam = this->first_seam; current_seam != nullptr) {
    while (current_seam != nullptr) {
      if (current_seam != part) {
        if (part->within(current_seam)) {
          if (!part->same_length(current_seam)) {
            part->type = Part::EXCLUSIVE;
            part->trasmuted = true;
            std::vector<Queueable<Point>*>& a = static_cast<Position*>(part->head)->end_point()->queues();
            a.erase(std::remove(a.begin(), a.end(), part), a.end());
            std::vector<Queueable<Point>*>& b = static_cast<Position*>(part->tail)->end_point()->queues();
            b.erase(std::remove(b.begin(), b.end(), part), b.end());
          }
        }
      }
      current_seam = current_seam->next_seam;
    }
  }
}

void Partitionable::transmute_parts()
{ Polyline *polyline = static_cast<Polyline*>(this);
  bool transpose = polyline->tile->cluster->finder()->transpose();
  if (Part* current_seam = this->first_seam; current_seam != nullptr) {
    while (current_seam != nullptr) {
      if (transpose) {
        transmute_transposed_part(current_seam);
      } else {
        if (!current_seam->transmutation_skip) {
          current_seam->try_transmutation();
        }
      }
      current_seam = current_seam->next_seam;
    }
  }
}
