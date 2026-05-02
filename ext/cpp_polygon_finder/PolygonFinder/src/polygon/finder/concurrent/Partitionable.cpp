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

  if (new_part->is(Part::SEAM)) new_part->orient();
}

void Partitionable::partition()
{ this->parts_.clear();
  Polyline *polyline = static_cast<Polyline*>(this);
  PartPool& pool = polyline->tile->cluster->parts_pool;
  Part *current_part = nullptr;
  int n = 0;
  Point* prev_position = nullptr;
  for (Point* position : polyline->raw())
  { if (polyline->tile->tg_border(*position))
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
    if (n > 0 && *prev_position == *position) {
      current_part->inverts = true;
    }
    current_part->add_position(position);
    n++;
    prev_position = position;
  }
  this->add_part(current_part);

  this->trasmute_parts();
}

void Partitionable::trasmute_parts()
{ std::vector<Part*> insides;
  for (Part* p : parts_) {
    if (p->is(Part::SEAM)) insides.push_back(p);
  }
  if (insides.size() < 2) return;

  for (Part* inside : insides)
  { for (Part* inside_compare : insides) {
      if (inside == inside_compare || !inside_compare->is(Part::SEAM) ) continue;
      int count = 0;
      inside->each([&](QNode<Point>* pos) -> bool {
        Position *position = static_cast<Position*>(pos);
        if (position->end_point()->queues_include(inside_compare))
        { count++;
          return true;
        }
        return false;
      });
      if (count == inside->size && count < inside_compare->size) {
        inside->type = Part::EXCLUSIVE;
        inside->trasmuted = true;
        break;
      }
    }
  }
}
