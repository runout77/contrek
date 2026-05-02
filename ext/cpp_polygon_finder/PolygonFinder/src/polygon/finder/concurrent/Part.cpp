/*
 * Part.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "Part.h"
#include <iostream>
#include <vector>
#include <string>
#include <sstream>
#include "Polyline.h"
#include "Tile.h"
#include "Cluster.h"

Part::Part(Types type, Polyline* polyline)
: type(type),
  polyline_(polyline) {
}

bool Part::is(Types type)
{ return(this->type == type);
}

Position* Part::next_position(Position* force_position) {
  if (force_position != nullptr)
  { QNode<Point>* move_to_this = nullptr;
    this->reverse_each([&](QNode<Point>* pos) -> bool {
      if (*(pos->payload) == *(force_position->payload)) {
        move_to_this = pos;
        return false;
      }
      return true;
    });
    if (move_to_this) next_of(move_to_this);
    return(force_position);
  } else {
    if (this->iterator() == nullptr) return(nullptr);
    Position *position = static_cast<Position*>(this->iterator());
    this->touched_ = true;
    this->forward();
    return(position);
  }
}

void Part::add_position(Point* point) {
  Cluster* c = this->polyline_->tile->cluster;
  Hub* hub = is(EXCLUSIVE) ? nullptr : c->hub();
  c->positions_pool.emplace_back(hub, point);
  this->add(&c->positions_pool.back());
}

bool Part::innerable()
{  return(!this->touched_ && is(EXCLUSIVE));
}

void Part::touch()
{  this->touched_ = true;
}

void Part::orient()
{ if (this->size <= 1 || (this->size == 2 && this->inverts)) {
    this->versus_ = 0;
  } else {
    this->versus_ = (this->tail->payload->y - this->head->payload->y) > 0 ? 1 : -1;
  }
}

std::string Part::inspect() {
  size_t part_index = 0;
  auto it = std::find(this->polyline()->parts().begin(), this->polyline()->parts().end(), this);
  if (it != this->polyline()->parts().end()) {
    part_index = std::distance(this->polyline()->parts().begin(), it);
  }
  std::stringstream ss;
  ss << "part " << part_index
  << " (versus=" << this->versus_
  << " inv=" << this->inverts
  << " trm=" << this->trasmuted
  << " touched=" << this->touched_
  << " dead_end=" << this->dead_end
  << ", " << this->size << "x) of " << this->polyline()->tile->name()
  << " (" << std::to_string(static_cast<uint32_t>(type)) << ") (";
  this->each([&](QNode<Point>* pos) -> bool {
    ss << pos->payload->toString();
    return true;
  });
  ss << ")";
  return ss.str();
}

std::vector<EndPoint*> Part::continuum_to(const Part& other_part) const {
  if (this->size <= 2 && this->inverts && other_part.size <= 2 && other_part.inverts) return {};

  Point* target = other_part.head->payload;
  QNode<Point>* cursor = this->tail;

  while (cursor != nullptr) {
    if (*cursor->payload == *target) {
      QNode<Point>* s = cursor;
      QNode<Point>* o = other_part.head;
      bool match = true;
      int count = 0;

      while (s != nullptr && o != nullptr) {
        if (!(*s->payload == *o->payload)) {
          match = false;
          break;
        }
        s = s->next;
        o = o->next;
        count++;
      }
      if (match && s == nullptr) {
        std::vector<EndPoint*> res;
        res.reserve(count);
        s = cursor;
        for (int i = 0; i < count; ++i) {
          res.push_back(static_cast<Position*>(s)->end_point());
          s = s->next;
        }
        return res;
      }
    }
    cursor = cursor->prev;
  }
  return {};
}
