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
  this->hub_ = new Hub(height);
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

  std::vector<Shape*> new_shapes;
  std::vector<InnerPolyline*> all_new_inner_polylines;

  timer.start();
  for (Tile* tile : tiles_) {
    for (Shape *shape : tile->shapes()) {
      if (shape->outer_polyline->is_on(Polyline::TRACKED_OUTER) || shape->outer_polyline->width() == 0) continue;
      if (shape->outer_polyline->boundary()) {
        shape->outer_polyline->partition();
      }
    }
  }
  tot_outer += timer.stop();

  for (Tile* tile : tiles_) {
    std::vector<Shape*>& src = tile->shapes();

    for (Shape* shape : src) {
      if (shape->outer_polyline->is_on(Polyline::TRACKED_OUTER) || shape->outer_polyline->width() == 0) {
        continue;
      }

      if (shape->outer_polyline->any_ancients) {
        Cursor cursor(*this, shape);
        Sequence* new_outer = nullptr;

        timer.start();
        new_outer = cursor.join_outers();
        tot_outer += timer.stop();

        timer.start();
        std::vector<InnerPolyline*> new_inners = shape->inner_polylines;
        std::vector<InnerPolyline*> new_inner_polylines = cursor.join_inners(new_outer, treemap);
        tot_inner += timer.stop();

        for (InnerPolyline* inner_polyline : new_inner_polylines) {
          new_inners.push_back(inner_polyline);
          if (treemap) {
            inner_polyline->sequence()->compute_vertical_bounds();
            all_new_inner_polylines.push_back(inner_polyline);
          }
        }
        for (auto s : cursor.orphan_inners()) {
          new_inners.push_back(s);
        }
        Polyline* polyline = tile->shapes_pool->acquire_polyline(tile, new_outer->to_vector(), std::nullopt);
        Shape* inserting_new_shape = tile->shapes_pool->acquire_shape(polyline, new_inners);
        new_shapes.push_back(inserting_new_shape);
        polyline->shape = inserting_new_shape;

        for (InnerPolyline* inner_polyline : new_inner_polylines) {
          inner_polyline->sequence()->shape = inserting_new_shape;
        }
        if (treemap) {
          for (const auto merged_shape : cursor.shapes_sequence()) {
            merged_shape->merged_to_shape = inserting_new_shape;
          }
          InnerPolyline* inside_inner_polyline = shape->outer_polyline->inside_inner_polyline;
          if (inside_inner_polyline) {
            assign_ancestry(inserting_new_shape, inside_inner_polyline);
          }
        }
      } else {
        if (treemap) {
          if (shape->fixed) {
            Shape* ms = shape->parent_shape()->merged_to_shape;
            if (ms) {
              shape->set_parent_shape(ms);
            }
          } else {
            is_children(shape, all_new_inner_polylines);
          }
        }
        new_shapes.push_back(shape);
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

void Cluster::assign_ancestry(Shape *shape, InnerPolyline* inner_polyline)
{ shape->set_parent_shape(inner_polyline->sequence()->shape);
  shape->parent_inner_polyline = inner_polyline;
  shape->fixed = true;
}

void Cluster::is_children(Shape* shape, std::vector<InnerPolyline*> inner_polylines) {
  int shape_max_y = shape->outer_polyline->max_y();
  int shape_min_y = shape->outer_polyline->min_y();
  for (InnerPolyline* inner_polyline : inner_polylines) {
    Bounds bounds = inner_polyline->vertical_bounds();
    int min_y = bounds.min;
    int max_y = bounds.max;
    if (shape_max_y < min_y || shape_min_y > max_y ) continue;
    if (shape->outer_polyline->within(inner_polyline->raw())) {
      assign_ancestry(shape, inner_polyline);
    }
  }
}
