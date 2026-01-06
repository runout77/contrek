/*
 * Cluster.cpp
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
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

Cluster::Cluster(Finder *finder, int height, int width)
  : finder(finder)
{ tiles_.reserve(2);  // only two (left|right)
  this->hub_ = new Hub(height, width);
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
  double tot_inner = 0;
  double tot_outer = 0;
  CpuTimer timer;
  std::list<Shape*> shapes;

  timer.start();
  for (Tile* tile : tiles_) {
    for (Shape *shape : tile->shapes()) {
      if (shape->outer_polyline->is_on(Polyline::TRACKED_OUTER) || shape->outer_polyline->width() == 0) continue;
      if (shape->outer_polyline->boundary())
      { shape->outer_polyline->partition();
        shape->outer_polyline->precalc();
      }
    }
  }
  tot_outer += timer.stop();

  for (Tile* tile : tiles_) {
    std::list<Shape*>& src = tile->shapes();
    for (auto it = src.begin(); it != src.end(); )
    { Shape* shape = *it;
      if (shape->outer_polyline->is_on(Polyline::TRACKED_OUTER) || shape->outer_polyline->width() == 0)
      { it++;
        continue;
      }

      if (shape->outer_polyline->boundary() && !shape->outer_polyline->next_tile_eligible_shapes().empty()) {
        Sequence* new_outer = nullptr;
        std::list<std::vector<Point*>> new_inners = shape->inner_polylines;
        Cursor cursor(*this, shape);
        timer.start();
        new_outer = cursor.join_outers();
        tot_outer += timer.stop();

        timer.start();
        std::vector<Sequence*> new_inner_sequences = cursor.join_inners(new_outer);
        tot_inner += timer.stop();

        for (Sequence* s : new_inner_sequences) {
          new_inners.push_back(s->to_vector());
          delete s;
        }
        for (auto s : cursor.orphan_inners()) {
          new_inners.push_back(s);
        }
        Polyline* polyline = new Polyline(tile, new_outer->to_vector());
        Shape* shape = new Shape(polyline, new_inners);
        shapes.push_back(shape);
        polyline->shape = shape;
        it++;
      } else {
        shapes.push_back(shape);
        it = src.erase(it);
      }
    }
  }
  double past_tot_outer = tiles_.front()->benchmarks.outer + tiles_.back()->benchmarks.outer;
  double past_tot_inner = tiles_.front()->benchmarks.inner + tiles_.back()->benchmarks.inner;
  Benchmarks b{
    tot_outer + past_tot_outer,
    tot_inner + past_tot_inner
  };
  Tile* tile = new Tile(this->finder, tiles_.front()->start_x(), tiles_.back()->end_x(), tiles_.front()->name() + tiles_.back()->name(), b);
  tile->assign_shapes(shapes);
  return(tile);
}

