/*
 * Tile.cpp
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include <string>
#include <iostream>
#include <list>
#include <utility>
#include "Tile.h"
#include "Shape.h"
#include "Polyline.h"

class Shape;
class Polyline;

Tile::Tile(Finder *finder, int start_x, int end_x, std::string name, const Benchmarks& b)
: finder(finder),
  start_x_(start_x),
  end_x_(end_x),
  name_(name),
  benchmarks(b) {
}

Tile::~Tile() {
  for (Shape* shape : shapes_) {
    delete shape;
  }
  shapes_.clear();
}

bool Tile::whole() {
  return(start_x_ == 0 && end_x_ == finder->maximum_width());
}

bool Tile::left() {
  return(start_x_ == 0);
}

bool Tile::right() {
  return(end_x_ == finder->maximum_width());
}

void Tile::initial_process(ClippedPolygonFinder *finder) {
  this->assign_raw_polygons(finder->get_cluster()->polygons);
}

void Tile::assign_raw_polygons(const std::list<Polygon>& raw_polylines) {
  for (const auto& raw_polyline : raw_polylines)
  { if (raw_polyline.bounds.width() > 0)
    { Polyline* polyline = new Polyline(this, raw_polyline.outer, raw_polyline.bounds);
      { Shape* shape = new Shape(polyline, raw_polyline.inner);
        polyline->shape = shape;
        this->shapes_.push_back(shape);
      }
    }
  }
}

void Tile::assign_shapes(std::list<Shape*>& shapes) {
  for (Shape *shape : shapes) {
    shape->outer_polyline->tile = this;
  }
  this->shapes_ = shapes;
}

bool Tile::tg_border(const Point& coord) {
  return( coord.x == (this->next == nullptr ? start_x_ : (end_x_ - 1)));
}

void Tile::info() {
  std::cout << "TILE name=" << name_ << " start_x=" << start_x_ << " end_x=" << end_x_ << std::endl;
}

const std::list<Shape*>& Tile::boundary_shapes()
{ if (!boundary_shapes_initialized_)
  { for (Shape* s : shapes_)
    { if (s->outer_polyline->boundary())
      { boundary_shapes_.push_back(s);
      }
    }
    boundary_shapes_initialized_ = true;
  }
  return boundary_shapes_;
}

std::list<Polygon> Tile::to_raw_polygons()
{ std::list<Polygon> retme;
  for (Shape* s : shapes_)
  { if (s->outer_polyline && !s->outer_polyline->is_empty())
    { Polygon poly;
      poly.outer = s->outer_polyline->raw();
      if (!s->inner_polylines.empty()) {
        for (auto inner : s->inner_polylines) {
          poly.inner.push_back(inner);
        }
      }
      retme.push_back(std::move(poly));
    }
  }
  return(retme);
}
