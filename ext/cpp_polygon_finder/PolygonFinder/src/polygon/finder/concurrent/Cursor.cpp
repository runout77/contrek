/*
 * Cursor.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */
#include <algorithm>
#include <vector>
#include <utility>
#include <unordered_set>
#include "Cursor.h"
#include "Polyline.h"
#include "InnerPolyline.h"

Cursor::Cursor(Cluster& cluster, Shape* shape)
: cluster(cluster), shape(shape) {
}

Sequence* Cursor::join_outers()
{ Polyline* outer_polyline = shape->outer_polyline;
  this->shapes_sequence_.push_back(this->shape);
  this->shapes_sequence_lookup.insert(this->shape);
  Sequence* outer_joined_polyline = outer_polyline->tile->shapes_pool->acquire_sequence();
  std::vector<Part*> all_parts;
  this->traverse_outer(outer_polyline->parts().front(),
                       all_parts,
                       this->shapes_sequence_,
                       outer_joined_polyline);

  if (*outer_joined_polyline->head->payload == *outer_joined_polyline->tail->payload &&
      this->cluster.tiles().front()->left() &&
      this->cluster.tiles().back()->right()) outer_joined_polyline->pop();

  for (Shape* shape : shapes_sequence_) {
    shape->outer_polyline->turn_on(Polyline::TRACKED_OUTER);
    if (shape == outer_polyline->shape) {
      continue;
    }
    orphan_inners_.insert(
        orphan_inners_.end(),
        shape->inner_polylines.begin(),
        shape->inner_polylines.end());
    shape->clear_inner();
  }
  return(outer_joined_polyline);
}

void Cursor::traverse_outer(Part* act_part,
                            std::vector<Part*>& all_parts,
                            std::vector<Shape*>& shapes_sequence,
                            Sequence* outer_joined_polyline) {
  while (act_part != nullptr) {
    Part* last_part = (!all_parts.empty()) ? all_parts.back() : nullptr;
    if (all_parts.empty() || last_part != act_part) {
      all_parts.push_back(act_part);
    }
    bool jumped_to_new_part = false;
    if (act_part->is(Part::EXCLUSIVE)) {
      if (act_part->size == 0) return;

      while (Position *position = act_part->next_position(nullptr)) {
        if (outer_joined_polyline->size > 1 &&
          outer_joined_polyline->head->payload == position->payload &&
          act_part == all_parts.front()) {
          return;
        }
        outer_joined_polyline->add(position);
      }
    } else {
      if (act_part->dead_end &&
         all_parts.size() > 1 &&
         last_part->is(Part::SEAM) &&
         last_part->polyline() == act_part->polyline()) return;
      while (Position *new_position = static_cast<Position*>(act_part->iterator())) {
        if (outer_joined_polyline->size > 1 &&
          outer_joined_polyline->head->payload == new_position->payload &&
          act_part == all_parts.front()) {
          return;
        }
        this->cluster.positions_pool.emplace_back(this->cluster.hub(), new_position->payload);
        outer_joined_polyline->add(&this->cluster.positions_pool.back());
        new_position->end_point()->tracked_outer = true;
        int versus = act_part->versus();
        auto& q_set = new_position->end_point()->queues();
        auto it = std::find_if(q_set.begin(), q_set.end(), [&](Queueable<Point>* q) {
          Part* p = static_cast<Part*>(q);
          return p->versus() == -versus && p->polyline()->tile != act_part->polyline()->tile;
        });

        Part* part = nullptr;
        if (it != q_set.end()) {
          part = static_cast<Part*>(*it);
        }
        if (part) {
          const auto n = all_parts.size();
          Part *last_last_part = n >= 2 ? all_parts[n - 2] : nullptr;
          if (last_last_part != part) {
            if (n >= 2) {
              bool all_seam = true;
              for (std::size_t i = all_parts.size() - 2; i < all_parts.size(); ++i) {
                if (all_parts[i]->type != Part::SEAM) {
                  all_seam = false;
                  break;
                }
              }
              if (all_seam) break;
            }
            if (shapes_sequence_lookup.insert(part->polyline()->shape).second) {
              shapes_sequence.push_back(part->polyline()->shape);
            }
            part->next_position(new_position);
            part->dead_end = true;
            act_part = part;
            jumped_to_new_part = true;
            break;
          }
        }
        if (!jumped_to_new_part) {
          act_part->next_position(nullptr);
        }
      }
    }
    if (jumped_to_new_part) continue;
    Part* next_part = act_part->circular_next;
    next_part->rewind();
    act_part = next_part;
  }
}

std::vector<InnerPolyline*> Cursor::join_inners(Sequence* outer_seq) {
  std::vector<InnerPolyline*> return_inner_polylines;
  std::vector<Shape*> processing_queue = shapes_sequence_;
  for (size_t i = 0; i < shapes_sequence_.size(); ++i)
  { Shape* shape = shapes_sequence_[i];
    Polyline* polyline = shape->outer_polyline;
    for (Part* part : polyline->parts())
    { if (part->innerable())
      { std::vector<Part*> all_parts;
        Bounds bounds{
          .min = polyline->max_y(),
          .max = 0
        };
        traverse_inner(part, all_parts, bounds);
        Sequence* retme_sequence = shape->outer_polyline->tile->shapes_pool->acquire_sequence();
        for (Part* part : all_parts)
        { part->touch();
          retme_sequence->move_from(*part, [&](QNode<Point>* pos) -> bool {
          Position *position = static_cast<Position*>(pos);
          if (part->is(Part::ADDED) &&
             !(position->payload->y >= bounds.min &&
              position->payload->y <= bounds.max)) {
            return(false);
          }
            return(!(polyline->tile->tg_border(*position->payload) && position->end_point()->tracked_outer));
          });
        }
        if (retme_sequence->is_not_vertical()) {
          return_inner_polylines.push_back(polyline->tile->shapes_pool->acquire_inner_polyline(retme_sequence));
        }
      }
    }
  }
  return(return_inner_polylines);
}

void Cursor::traverse_inner(Part* act_part, std::vector<Part*>& all_parts, Bounds& bounds) {
  PartPool& pool = act_part->polyline()->tile->cluster->parts_pool;
  while (act_part != nullptr) {
    if (!all_parts.empty() && act_part == all_parts.front()) return;
    if (act_part->size > 0) {
      auto points = act_part->to_vector();
      auto [min_it, max_it] = std::minmax_element(
        points.begin(),
        points.end(),
        [](Point* a, Point* b) { return a->y < b->y; });
      bounds.min = std::min(bounds.min, (*min_it)->y);
      bounds.max = std::max(bounds.max, (*max_it)->y);
    }
    if (act_part->innerable()) {
      all_parts.push_back(act_part);
      bool jumped = false;
      while (act_part = act_part->circular_next) {
        if (act_part->innerable()) {
            all_parts.push_back(act_part);
        } else {
          if (act_part->head)
          { for (auto dest_part_p : static_cast<Position*>(act_part->head)->end_point()->queues()) {
              Part* dest_part = static_cast<Part*>(dest_part_p);
              if (dest_part->polyline()->tile == act_part->polyline()->tile) {
                continue;
              }
              int dest_part_versus = dest_part->versus();
              if (dest_part_versus != 0 && dest_part_versus == act_part->versus()) continue;
              std::vector<EndPoint*> link_seq = dest_part->continuum_to(*act_part);
              if (!link_seq.empty()) {
                Part* ins_part = pool.acquire(Part::ADDED, act_part->polyline());
                for (EndPoint* pos : link_seq) {
                  this->cluster.positions_pool.emplace_back(pos);
                  ins_part->add(&this->cluster.positions_pool.back());
                }
                all_parts.push_back(ins_part);
              }
              Shape* shape = dest_part->polyline()->shape;
              if (!dest_part->polyline()->is_on(Polyline::TRACKED_OUTER))
              { shapes_sequence_.push_back(shape);
                orphan_inners_.insert(
                  orphan_inners_.end(),
                  shape->inner_polylines.begin(),
                  shape->inner_polylines.end());
              }
              dest_part->polyline()->turn_on(Polyline::TRACKED_OUTER);
              if (!dest_part->touched()) {
                dest_part->touch();

                act_part = dest_part->circular_next;
                jumped = true;
                break;
              }
            }
            if (jumped) break;
          }
          if (act_part->is(Part::SEAM)) {
            all_parts.push_back(act_part);
          }
        }
      }
      if (jumped) continue;
      break;
    } else if (act_part->next) {
      act_part = act_part->next;
      continue;
    }
    else break;
  }
}
