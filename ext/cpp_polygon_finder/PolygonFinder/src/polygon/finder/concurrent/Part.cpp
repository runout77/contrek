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
      move_to_this = pos;
      if (pos->payload == force_position->payload) {
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

void Part::add_position(const Point& point) {
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
{ if (this->size <= 1) {
    this->versus_ = 0;
  } else {
    int diff = this->tail->payload.y - this->head->payload.y;
    if (diff == 0) {
      this->versus_ = 0;
    } else {
      this->versus_ = diff > 0 ? 1 : -1;
    }
  }
}

constexpr std::string_view typeToString(Part::Types t) noexcept {
  switch (t) {
    case Part::SEAM:      return "SEAM";
    case Part::EXCLUSIVE: return "EXCLUSIVE";
    default:        return "UNKNOWN";
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
  << " touched=" << this->touched_
  << ", " << this->size << "x) of " << this->polyline()->tile->name() << " " << this->polyline()->named()
  << " (" << typeToString(type) << ") (";
  this->each([&](QNode<Point>* pos) -> bool {
    ss << pos->payload.toString();
    return true;
  });
  ss << ")";
  return ss.str();
}
