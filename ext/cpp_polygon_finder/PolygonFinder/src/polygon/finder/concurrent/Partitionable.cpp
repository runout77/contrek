/*
 * Partitionable.cpp
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include <vector>
#include <utility>
#include <iostream>
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
}

void Partitionable::partition()
{ this->parts_.clear();
  Polyline *polyline = dynamic_cast<Polyline*>(this);
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

Part* Partitionable::find_first_part_by_position(Position* position) {
  for (Part* part : this->parts_)
  { if ( part->is(Part::SEAM) &&
      part->passes == 0 &&
      position->end_point()->queues_include(part)) return(part);
  }
  return(nullptr);
}

std::pair<
std::vector<std::vector<Point*>>,
    std::vector<std::vector<Point*>>
>
Partitionable::sew(std::vector<Point*> intersection, Polyline* other)
{   std::vector<int> matching_part_indexes;
  for (int i = 0; i < static_cast<int>(parts_.size()); ++i) {
    Part* part = parts_[i];
    if (!part || part->trasmuted) continue;
    if (part->intersection_with_array(intersection)) {
      matching_part_indexes.push_back(i);
    }
  }
  std::vector<int> other_matching_part_indexes;
  for (int i = 0; i < static_cast<int>(other->parts_.size()); ++i) {
    Part* part = other->parts_[i];
    if (!part || part->trasmuted) continue;
    if (part->intersection_with_array(intersection)) {
        other_matching_part_indexes.push_back(i);
    }
  }
  std::vector<Part*> before_parts;
  for (int i = other_matching_part_indexes.back() + 1;
       i < static_cast<int>(other->parts_.size()); ++i)
  { before_parts.push_back(other->parts_[i]);
  }
  std::vector<Part*> after_parts;
  for (int i = 0; i < other_matching_part_indexes.front(); ++i) {
    after_parts.push_back(other->parts_[i]);
  }
  Part* part_start = parts_[matching_part_indexes.front()];
  Part* part_end   = parts_[matching_part_indexes.back()];
  // They are inverted since they traverse in opposite directions
  Sequence sequence;
  sequence.add(part_start->head);
  for (Part* p : before_parts) sequence.append(*p);
  for (Part* p : after_parts) sequence.append(*p);
  if (part_end->tail) sequence.add(part_end->tail);
  part_start->replace(sequence);
  part_start->type = Part::EXCLUSIVE;
  if (part_start != part_end) part_end->reset();

  std::vector<std::vector<Point*>> left;

  for (int n = matching_part_indexes.front() + 1;
       n <= matching_part_indexes.back() - 1;
       ++n)
  { if (std::find(matching_part_indexes.begin(),
                  matching_part_indexes.end(),
                  n) == matching_part_indexes.end())
    { auto pts = parts_[n]->to_vector();
      left.push_back(pts);
    }
  }

  // delete parts in reverse order
  for (int n = matching_part_indexes.back() - 1;
       n >= matching_part_indexes.front() + 1;
       --n)
  { Part* delete_part = parts_[n];
    if (delete_part->prev) delete_part->prev->next = delete_part->next;
    if (delete_part->next) delete_part->next->prev = delete_part->prev;
    parts_.erase(parts_.begin() + n);
  }

  std::vector<std::vector<Point*>> right;
  for (int n = other_matching_part_indexes.front() + 1;
       n <= other_matching_part_indexes.back() - 1;
       ++n)
  { if (std::find(other_matching_part_indexes.begin(),
                  other_matching_part_indexes.end(),
                  n) == other_matching_part_indexes.end())
    { auto pts = other->parts_[n]->to_vector();
      right.push_back(pts);
    }
  }
  return { left, right };
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
      bool all_match = true;
      inside->each([&](QNode<Point>* pos) -> bool {
        Position *position = dynamic_cast<Position*>(pos);
        if (position->end_point()->queues_include(inside_compare))
        { return true;
        }
        all_match = false;
        return false;
      });
      if (all_match) {
        inside->type = Part::EXCLUSIVE;
        inside->trasmuted = true;
        break;
      }
    }
  }
}

