/*
 * Cursor.cpp
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */
#include <algorithm>
#include <vector>
#include <utility>
#include <unordered_set>
#include "Cursor.h"
#include "Polyline.h"

Cursor::Cursor(Cluster& cluster, Shape* shape)
: cluster(cluster), shape(shape) {
}

Cursor::~Cursor() {
  for (Sequence* sequence : this->allocated_sequences) {
    delete sequence;
  }
}

Sequence* Cursor::join_outers()
{ Polyline* outer_polyline = shape->outer_polyline;
  this->shapes_sequence.push_back(this->shape);
  this->shapes_sequence_lookup.insert(this->shape);
  Sequence* outer_joined_polyline = new Sequence();
  this->allocated_sequences.push_back(outer_joined_polyline);
  std::vector<Part*> all_parts;
  this->traverse_outer(outer_polyline->parts().front(),
                       all_parts,
                       this->shapes_sequence,
                       outer_joined_polyline);

  if (*outer_joined_polyline->head->payload == *outer_joined_polyline->tail->payload &&
      this->cluster.tiles().front()->left() &&
      this->cluster.tiles().back()->right()) outer_joined_polyline->pop();

  for (Shape* shape : shapes_sequence) {
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
    if (all_parts.empty() || all_parts.back() != act_part) {
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
      while (Position *new_position = static_cast<Position*>(act_part->iterator())) {
        if (outer_joined_polyline->size > 1 &&
          outer_joined_polyline->head->payload == new_position->payload &&
          act_part == all_parts.front()) {
          return;
        }
        this->cluster.positions_pool.emplace_back(this->cluster.hub(), new_position->payload);
        outer_joined_polyline->add(&this->cluster.positions_pool.back());
        for (Shape *shape : act_part->polyline()->next_tile_eligible_shapes()) {
          if (Part *part = shape->outer_polyline->find_first_part_by_position(new_position)) {
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
              act_part = part;
              jumped_to_new_part = true;
              break;
            }
          }
        }
        if (jumped_to_new_part) break;
        act_part->passes += 1;
        act_part->next_position(nullptr);
      }
    }
    if (jumped_to_new_part) continue;
    Part* next_part = act_part->circular_next;
    next_part->rewind();
    act_part = next_part;
  }
}

std::vector<Sequence*> Cursor::join_inners(Sequence* outer_seq) {
  std::vector<Sequence*> retme;
  std::vector<Shape*> missing_shapes;

  for (Tile *tile : this->cluster.tiles())
  { for (Shape *shape : tile->shapes())
    { if (shape->outer_polyline->is_on(Polyline::TRACKED_OUTER) ||
        shape->outer_polyline->is_on(Polyline::TRACKED_INNER) ||
        !shape->outer_polyline->boundary() ||
        std::find(shapes_sequence.begin(), shapes_sequence.end(), shape) != shapes_sequence.end()) {
        continue;
      }
      missing_shapes.push_back(shape);
    }
  }

  if (missing_shapes.size() > 0) {
    std::vector<Shape*> to_delay_shapes;
    to_delay_shapes = connect_missings(this->shapes_sequence, missing_shapes);
    if (!to_delay_shapes.empty())
    { connect_missings(to_delay_shapes, missing_shapes);
      while (!to_delay_shapes.empty()) {
        to_delay_shapes = connect_missings(this->shapes_sequence, to_delay_shapes);
      }
    }
  }

  retme = collect_inner_sequences(outer_seq);
  for (Shape* shape : shapes_sequence) {
    shape->outer_polyline->turn_on(Polyline::TRACKED_INNER);
  }
  return(retme);
}

std::vector<Shape*> Cursor::connect_missings(std::vector<Shape*> shapes_sequence, std::vector<Shape*> missing_shapes) {
  std::vector<Shape*> delay_shapes;

  for (Shape* shape : shapes_sequence)
  { Polyline* polyline = shape->outer_polyline;
    for (Shape* missing_shape : missing_shapes)
    { Polyline* outer_polyline = missing_shape->outer_polyline;
      if ( (polyline->mixed_tile_origin == false && outer_polyline->tile == polyline->tile) ||
           outer_polyline->is_on(Polyline::TRACKED_OUTER)  ||
           !polyline->vert_intersect(*outer_polyline)) continue;
      std::vector<std::pair<int, int>> intersection = polyline->intersection(outer_polyline);
      if (intersection.size() > 0)
      { auto result = polyline->sew(intersection, outer_polyline);
        if (!result) {
          delay_shapes.push_back(missing_shape);
          continue;
        }
        auto& inject_sequences_left = result->first;
        auto& inject_sequences_right = result->second;
        auto combined = combine(inject_sequences_right, inject_sequences_left);
        for (auto& sewn_sequence : combined) {
          std::vector<Point*> unique;
          unique.reserve(sewn_sequence.size());
          for (Point* p : sewn_sequence) {
            if (!p) continue;
            auto it = std::find_if(
              unique.begin(), unique.end(),
              [&](Point* up) {
                  return up && *up == *p;
              });
            if (it == unique.end()) unique.push_back(p);
          }
          sewn_sequence.swap(unique);

          if (sewn_sequence.size() <= 1) continue;

          int first_x = sewn_sequence.front()->x;
          bool different_x = false;
          for (Point* p : sewn_sequence) {
            if (p->x != first_x) {
              different_x = true;
              break;
            }
          }
          if (different_x) {
            orphan_inners_.push_back(sewn_sequence);
          }
        }
        polyline->mixed_tile_origin = true;
        outer_polyline->clear();
        outer_polyline->turn_on(Polyline::TRACKED_OUTER);
        outer_polyline->turn_on(Polyline::TRACKED_INNER);
        orphan_inners_.insert(
        orphan_inners_.end(),
        missing_shape->inner_polylines.begin(),
        missing_shape->inner_polylines.end());
      }
    }
  }

  return(delay_shapes);
}

std::vector<Sequence*> Cursor::collect_inner_sequences(Sequence* outer_seq) {
  std::vector<Sequence*> return_sequences;

  for (Shape* shape : shapes_sequence)
  { Polyline* polyline = shape->outer_polyline;
    for (Part* part : polyline->parts())
    { if (part->innerable())
      { std::vector<Part*> all_parts;
        Bounds bounds{
          .min = polyline->max_y(),
          .max = 0
        };
        traverse_inner(part, all_parts, bounds);
        Sequence* retme_sequence = new Sequence();

        for (Part* part : all_parts)
        { part->touch();
          retme_sequence->move_from(*part, [&](QNode<Point>* pos) -> bool {
          Position *position = dynamic_cast<Position*>(pos);
          if (part->is(Part::ADDED) &&
             !(position->payload->y >= bounds.min &&
              position->payload->y <= bounds.max)) {
            return(false);
          }
            return(!(polyline->tile->tg_border(*position->payload) && position->end_point()->queues_include(outer_seq)));
          });
        }
        if (retme_sequence->is_not_vertical()) return_sequences.push_back(retme_sequence);
        else                                   delete retme_sequence;
      }
    }
  }

  return(return_sequences);
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
      while (act_part = act_part->next) {
        if (act_part->innerable()) {
            all_parts.push_back(act_part);
        } else {
          for (Shape *shape : act_part->polyline()->next_tile_eligible_shapes()) {
            for (Part* dest_part : shape->outer_polyline->parts()) {
              if (dest_part->trasmuted || dest_part->is(Part::EXCLUSIVE)) continue;
              if (dest_part->intersect_part(act_part)) {
                std::vector<EndPoint*> link_seq = duplicates_intersection(*dest_part, *act_part);
                if (!link_seq.empty()) {
                  Part* ins_part = pool.acquire(Part::ADDED, act_part->polyline());
                  for (EndPoint* pos : link_seq) {
                    this->cluster.positions_pool.emplace_back(pos);
                    ins_part->add(&this->cluster.positions_pool.back());
                  }
                  all_parts.push_back(ins_part);
                }
                shape->outer_polyline->turn_on(Polyline::TRACKED_OUTER);
                shape->outer_polyline->turn_on(Polyline::TRACKED_INNER);
                act_part = dest_part->circular_next;
                jumped = true;
                break;
              }
            }
            if (jumped) break;
          }
          if (jumped) break;
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

template <typename T>
std::vector<T*> difference_ptr(std::vector<T*>& a, std::vector<T*>& b)
{ std::vector<T*> result;
  for (T* item : a) {
    auto it = std::find_if(
      b.begin(), b.end(),
      [&](T* other) {
        return other == item;
      });
    if (it == b.end()) {
      result.push_back(item);
    }
  }
  return result;
}

std::vector<EndPoint*> Cursor::duplicates_intersection(Part& part_a, Part& part_b) {
  auto a1 = part_a.to_endpoints();
  auto b1 = part_b.to_endpoints();
  if (part_a.inverts) a1 = Part::remove_adjacent_pairs(a1);
  if (part_b.inverts) b1 = Part::remove_adjacent_pairs(b1);
  std::vector<EndPoint*> result = difference_ptr(a1, b1);
  std::vector<EndPoint*> temp = difference_ptr(b1, a1);
  result.insert(result.end(), temp.begin(), temp.end());
  return result;
}

std::vector<std::vector<Point*>> Cursor::combine(std::vector<std::vector<Point*>>& seqa, std::vector<std::vector<Point*>>& seqb)
{ std::vector<std::vector<Point*>> rets;
  size_t n = std::min(seqa.size(), seqb.size());
  for (size_t i = 0; i < n; ++i) {
    std::vector<Point*> last = std::move(seqa.back());
    seqa.pop_back();
    std::vector<Point*> first = std::move(seqb.front());
    seqb.erase(seqb.begin());
    first.insert(first.end(), last.begin(), last.end());
    rets.push_back(std::move(first));
  }
  return rets;
}
