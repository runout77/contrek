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

  this->trasmute_parts();
}

void Partitionable::trasmute_parts()
{ Polyline *polyline = static_cast<Polyline*>(this);
  bool transpose = polyline->tile->cluster->finder()->transpose();

  for (Part* inside : parts_) {
    if (!inside->is(Part::SEAM)) continue;
    for (Part* inside_compare : parts_) {
      if (inside == inside_compare || !inside_compare->is(Part::SEAM)) continue;

      if (transpose) {
        if (inside->within(inside_compare)) {
          Part* target_part;
          if (!inside->same_length(inside_compare)) {
            target_part = inside;
            target_part->type = Part::EXCLUSIVE;
            target_part->trasmuted = true;
            std::vector<Queueable<Point>*>& a = static_cast<Position*>(target_part->head)->end_point()->queues();
            a.erase(std::remove(a.begin(), a.end(), target_part), a.end());
            std::vector<Queueable<Point>*>& b = static_cast<Position*>(target_part->tail)->end_point()->queues();
            b.erase(std::remove(b.begin(), b.end(), target_part), b.end());
            break;
          }
        }
      } else {
        int count = 0;
        inside->each([&](QNode<Point>* pos) -> bool {
          Position *position = static_cast<Position*>(pos);
          if (position->end_point()->queues_include(inside_compare))
          { count++;
            return true;
          }
          return false;
        });
        if (count == inside->size) {
          if (count < inside_compare->size) {
            inside->type = Part::EXCLUSIVE;
            inside->trasmuted = true;
            break;
          } else if ( count == inside_compare->size &&
                      inside->next == nullptr &&
                      inside_compare->prev == nullptr) {
            inside->mirror = true;
          }
        }
      }
    }
  }
}
