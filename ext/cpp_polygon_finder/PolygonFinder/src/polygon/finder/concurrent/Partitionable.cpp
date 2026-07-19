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
  new_part->circular_next = this->parts_.front();

  if (new_part->is(Part::SEAM)) {
    new_part->orient();
  }
}

void Partitionable::partition()
{ this->parts_.clear();
  Polyline *polyline = static_cast<Polyline*>(this);
  PartPool& pool = polyline->tile->cluster->parts_pool;
  Part *current_part = nullptr;

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
    current_part->add_position(position);
  }
  this->add_part(current_part);
}
