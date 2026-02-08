/*
 * Part.cpp
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include "Part.h"
#include <iostream>
#include <vector>
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

bool Part::intersect_part(Part* other_part)
{ bool intersect = false;
  other_part->each([&](QNode<Point>* pos) -> bool {
    Position *position = dynamic_cast<Position*>(pos);
    if (position->end_point()->queues_include(this))
    { intersect = true;
      return(false);
    }
    return(true);
  });
  return(intersect);
}

std::vector<EndPoint*> Part::to_endpoints() {
  std::vector<EndPoint*> out;
  QNode<Point>* current = head;
  while (current) {
    out.push_back((dynamic_cast<Position*>(current))->end_point());
    current = current->next;
  }
  return out;
}

std::vector<EndPoint*> Part::remove_adjacent_pairs(const std::vector<EndPoint*>& input = {}) {
  std::vector<EndPoint*> result;
  result.reserve(input.size());
  for (EndPoint* current : input) {
    if (!result.empty() && result.back() == current) {
      result.pop_back();
    } else {
      result.push_back(current);
    }
  }
  return result;
}
