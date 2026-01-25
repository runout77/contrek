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
}

void Partitionable::insert_after(Part* part, Part* new_part) {
  auto it = std::find(parts_.begin(), parts_.end(), part);
  if (it != parts_.end()) parts_.insert(it + 1, new_part);
  new_part->prev = part;
  new_part->next = part->next;
  new_part->circular_next = part->next;
  if (part->next) part->next->prev = new_part;
  part->next = new_part;
  part->circular_next = new_part;
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

std::optional<SewReturnData> Partitionable::sew(std::vector<std::pair<int, int>> intersection, Polyline* other)
{ std::vector<int> matching_part_indexes;
  std::vector<int> other_matching_part_indexes;
  matching_part_indexes.reserve(intersection.size());
  other_matching_part_indexes.reserve(intersection.size());

  // traspose
  for (const auto& pair : intersection) {
    matching_part_indexes.push_back(pair.first);
    other_matching_part_indexes.push_back(pair.second);
  }
  std::sort(matching_part_indexes.begin(), matching_part_indexes.end());
  std::sort(other_matching_part_indexes.begin(), other_matching_part_indexes.end());

  auto start_it_before = other->parts_.begin() + other_matching_part_indexes.back() + 1;
  auto end_it_before   = other->parts_.end();
  std::vector<Part*> before_parts(start_it_before, end_it_before);
  auto start_it_after = other->parts_.begin();
  auto end_it_after   = other->parts_.begin() + other_matching_part_indexes.front();
  std::vector<Part*> after_parts(start_it_after, end_it_after);

  int start_idx = matching_part_indexes.front();
  int end_idx  = matching_part_indexes.back();
  Part* part_start = parts_[start_idx];
  Part* part_end   = parts_[end_idx];

  auto collect_sequences = [&](const std::vector<int>& indices, std::vector<Part*>& p_list)
    -> std::vector<std::vector<Point*>> {
    std::vector<std::vector<Point*>> result;
    int last_n = -1;
    if (indices.size() < 2) return result;
    for (int n = indices.front() + 1; n < indices.back(); ++n) {
      if (std::find(indices.begin(), indices.end(), n) == indices.end()) {
        Part* part = p_list[n];
        if (part->is(Part::SEAM) && part->size > 0 && !part->delayed) {
          part->delayed = true;
          result.clear();
          result.push_back({nullptr});
          return result;
        }
        if (last_n == (n - 1) && !result.empty()) {
          std::vector<Point*> pts = part->to_vector();
          result.back().insert(result.back().end(), pts.begin(), pts.end());
        } else {
          result.push_back(part->to_vector());
        }
        last_n = n;
      }
    }
    return result;
  };
  auto left = collect_sequences(matching_part_indexes, this->parts_);
  if (!left.empty() && !left[0].empty() && left[0][0] == nullptr) {
    return std::nullopt;
  }
  auto right = collect_sequences(other_matching_part_indexes, other->parts_);
  if (!right.empty() && !right[0].empty() && right[0][0] == nullptr) {
    return std::nullopt;
  }

  if (part_start != part_end) {
    for (int n = end_idx - 1; n > start_idx; --n) {
      Part* delete_part = parts_[n];
      // Topological detachment of pointers
      if (delete_part->prev) delete_part->prev->next = delete_part->next;
      if (delete_part->next) delete_part->next->prev = delete_part->prev;
      parts_.erase(parts_.begin() + n);
    }
  }

  std::vector<Part*> all_parts;
  Polyline* polyline = dynamic_cast<Polyline*>(this);
  all_parts.reserve(before_parts.size() + after_parts.size());
  all_parts.insert(all_parts.end(), before_parts.begin(), before_parts.end());
  all_parts.insert(all_parts.end(), after_parts.begin(), after_parts.end());
  Part* will_be_last = all_parts.empty() ? nullptr : all_parts.back();
  for (auto it = all_parts.rbegin(); it != all_parts.rend(); ++it) {
    Part* p = *it;
    this->insert_after(part_start, p);
    auto& op = other->parts_;
    op.erase(std::remove(op.begin(), op.end(), p), op.end());
    p->set_polyline(polyline);
  }

  part_start->type = Part::EXCLUSIVE;
  PartPool& pool = polyline->tile->cluster->parts_pool;
  Part* new_end_part = pool.acquire(Part::EXCLUSIVE, polyline);
  new_end_part->add(part_end->tail);
  part_start->singleton();

  // deletes part_end
  if (part_start != part_end) {
    if (part_end->prev) part_end->prev->next = part_end->next;
    if (part_end->next) part_end->next->prev = part_end->prev;
    auto it = std::find(parts_.begin(), parts_.end(), part_end);
    if (it != parts_.end()) {
      parts_.erase(it);
    }
  }

  Part* reference_part = (will_be_last != nullptr) ? will_be_last : part_start;
  this->insert_after(reference_part, new_end_part);

  polyline->reset_tracked_endpoints();

  return std::make_pair(left, right);
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

