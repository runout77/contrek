/*
 * Cluster.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <vector>
#include <list>
#include <iostream>
#include "Cluster.h"
#include "Shape.h"
#include "Polyline.h"
#include "Sequence.h"
#include "Cursor.h"
#include "../../CpuTimer.h"

Cluster::Cluster(Finder *finder, int height, int start_x, int end_x)
  : finder(finder)
{ tiles_.reserve(2);  // only two (left|right)
  this->hub_ = new Hub(height, start_x, end_x);
}

Cluster::~Cluster() {
  for (Tile* tile : tiles_) {
    delete tile;
  }
  delete this->hub_;
}

void Cluster::add(Tile* tile) {
  Tile* last_tile = tiles_.empty() ? nullptr : tiles_.back();
  tiles_.push_back(tile);
  tile->cluster = this;
  if (last_tile) {
    last_tile->next = last_tile->circular_next = tile;
    tile->prev = tile->circular_next = last_tile;
  }
}

void Cluster::list_to_string(std::vector<Point*> list)
{ std::cout << "(" << &list << ") ";
  for (Point* point : list) {
    std::cout << point->toString();
  }
  std::cout << std::endl;
}

Tile* Cluster::merge_tiles() {
  bool treemap = this->finder->options().treemap;
  double tot_inner = 0;
  double tot_outer = 0;
  CpuTimer timer;

  std::list<Shape*> new_shapes;
  std::vector<InnerPolyline*> all_new_inner_polylines;

  timer.start();
  for (Tile* tile : tiles_) {
    for (Shape *shape : tile->shapes()) {
      if (shape->outer_polyline->is_on(Polyline::TRACKED_OUTER) || shape->outer_polyline->width() == 0) continue;
      if (shape->outer_polyline->boundary()) {
        shape->outer_polyline->partition();
        shape->outer_polyline->precalc();
      }
    }
  }
  tot_outer += timer.stop();

  for (Tile* tile : tiles_) {
    std::list<Shape*>& src = tile->shapes();

    for (Shape* shape : src) {
      if (shape->outer_polyline->is_on(Polyline::TRACKED_OUTER) || shape->outer_polyline->width() == 0) {
        continue;
      }

      if (shape->outer_polyline->boundary() && !shape->outer_polyline->next_tile_eligible_shapes().empty()) {
        Cursor cursor(*this, shape);
        Sequence* new_outer = nullptr;

        timer.start();
        new_outer = cursor.join_outers();
        tot_outer += timer.stop();

        timer.start();
        std::vector<InnerPolyline*> new_inners = shape->inner_polylines;
        std::vector<InnerPolyline*> new_inner_polylines = cursor.join_inners(new_outer);
        tot_inner += timer.stop();

        for (InnerPolyline* inner_polyline : new_inner_polylines) {
          new_inners.push_back(inner_polyline);
          if (treemap) {
            inner_polyline->sequence()->compute_vertical_bounds();
            all_new_inner_polylines.push_back(inner_polyline);
            for (const auto orphan_inner : cursor.orphan_inners()) {
              if (orphan_inner->recombined()) {
                all_new_inner_polylines.push_back(orphan_inner);
              }
            }
          }
        }

        for (auto s : cursor.orphan_inners()) {
          new_inners.push_back(s);
        }

        Polyline* polyline = tile->shapes_pool->acquire_polyline(tile, new_outer->to_vector(), std::nullopt);
        Shape* inserting_new_shape = tile->shapes_pool->acquire_shape(polyline, new_inners);

        new_shapes.push_back(inserting_new_shape);
        polyline->shape = inserting_new_shape;
        inserting_new_shape->set_parent_shape(shape->parent_shape());

        for (InnerPolyline* inner_polyline : new_inner_polylines) {
          inner_polyline->sequence()->shape = inserting_new_shape;
        }

        if (treemap) {
          for (const auto merged_shape : cursor.shapes_sequence()) {
            merged_shape->merged_to_shape = inserting_new_shape;
          }
          this->assign_ancestry(inserting_new_shape, all_new_inner_polylines);
        }

      } else {
        if (treemap && !shape->reassociation_skip && shape->parent_shape() == nullptr) {
          this->assign_ancestry(shape, all_new_inner_polylines);
        }
        new_shapes.push_back(shape);
      }
    }
  }

  if (treemap) {
    for (Tile* tile : tiles_) {
      for (Shape* shape : tile->shapes()) {
        Shape* parent = shape->parent_shape();
        while (parent && parent->merged_to_shape != nullptr) {
          parent = parent->merged_to_shape;
        }
        if (parent != shape->parent_shape()) {
          shape->set_parent_shape(parent);
        }
      }
    }
  }

  double past_tot_outer = tiles_.front()->benchmarks.outer + tiles_.back()->benchmarks.outer;
  double past_tot_inner = tiles_.front()->benchmarks.inner + tiles_.back()->benchmarks.inner;

  Benchmarks b{
    tot_outer + past_tot_outer,
    tot_inner + past_tot_inner
  };

  Tile* tile = new Tile(
    this->finder, tiles_.front()->start_x(), tiles_.back()->end_x(), tiles_.front()->name() + tiles_.back()->name(), b);

  tile->assign_shapes(new_shapes);
  for (Tile* old_tile : tiles_) {
    tile->adopt(old_tile);
  }
  return tile;
}

void Cluster::assign_ancestry(Shape *shape, std::vector<InnerPolyline*>& inner_polylines)
{ for (auto* inner_polyline : inner_polylines) {
    if (shape->outer_polyline->vert_bounds_intersect(inner_polyline->vertical_bounds())) {
      if (shape->outer_polyline->within(inner_polyline->raw())) {
        shape->set_parent_shape(inner_polyline->shape());
        shape->parent_inner_polyline = inner_polyline;
        for (auto* children_shape : shape->children_shapes) {
          children_shape->reassociation_skip = true;
        }
      }
    }
  }
}
