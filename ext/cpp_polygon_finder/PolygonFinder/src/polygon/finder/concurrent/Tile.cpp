/*
 * Tile.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <string>
#include <iostream>
#include <list>
#include <utility>
#include <vector>
#include <unordered_map>
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
  this->shapes_pool = new ShapePool();
  this->shapes_pools.push_back(this->shapes_pool);
}

Tile::~Tile() {
  shapes_.clear();
  for (ShapePool* pool : this->shapes_pools) {
    delete pool;
  }
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
  this->assign_raw_polygons(finder->get_cluster()->polygons, finder->get_cluster()->treemap);
}

void Tile::assign_raw_polygons(const std::list<Polygon>& raw_polylines, const std::vector<std::pair<int, int>>& treemap) {
  std::unordered_map<int, Shape*> shapes_map;
  int polyline_index = 0;
  for (const auto& raw_polyline : raw_polylines)
  { if (raw_polyline.bounds.width() > 0)
    { Polyline* polyline = this->shapes_pool->acquire_polyline(this, raw_polyline.outer, raw_polyline.bounds);
      std::vector<InnerPolyline*> inner_polylines_list;
      for (auto& raw_points : raw_polyline.inner) {
        inner_polylines_list.push_back(this->shapes_pool->acquire_inner_polyline(raw_points, nullptr, false));
      }
      Shape* shape = this->shapes_pool->acquire_shape(polyline, inner_polylines_list);
      polyline->shape = shape;
      this->shapes_.push_back(shape);

      if (treemap.size() > 0)
      { auto treemap_entry = treemap[polyline_index];
        shapes_map[polyline_index] = shape;
        if (treemap_entry.first != -1 && treemap_entry.second != -1) {
          auto it = shapes_map.find(treemap_entry.first);
          if (it != shapes_map.end()) {
            Shape* parent = it->second;
            shape->set_parent_shape(parent);
            shape->parent_inner_polyline = parent->inner_polylines[treemap_entry.second];
          }
        }
      }
    }
    polyline_index++;
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
  std::cout << this->toString() << std::endl;
}

std::string Tile::toString() {
  std::string s = "TILE name=" + name_ + " start_x=" + std::to_string(start_x_) + " end_x=" + std::to_string(end_x_);
  return s;
}

std::list<Polygon> Tile::to_raw_polygons()
{ std::list<Polygon> retme;
  for (Shape* s : shapes_)
  { if (s->outer_polyline && !s->outer_polyline->is_empty())
    { Polygon poly;
      poly.outer = s->outer_polyline->raw();
      if (!s->inner_polylines.empty()) {
        for (auto inner : s->inner_polylines) {
          poly.inner.push_back(inner->raw());
        }
      }
      retme.push_back(std::move(poly));
    }
  }
  return(retme);
}

std::vector<std::pair<int, int>> Tile::compute_treemap()
{ std::unordered_map<Shape*, int> shapes_map;
  int current_index = 0;

  for (auto* shape : this->shapes_) {
    if (shape->outer_polyline->is_empty()) continue;
    shapes_map[shape] = current_index++;
  }
  std::vector<std::pair<int, int>> treemap;
  treemap.reserve(shapes_map.size());

  for (auto* shape : this->shapes_) {
    if (shape->outer_polyline->is_empty()) continue;
    if (shape->parent_shape() != nullptr) {
      int p_idx = shapes_map[shape->parent_shape()];
      const auto& inners = shape->parent_shape()->inner_polylines;
      auto it = std::find(inners.begin(), inners.end(), shape->parent_inner_polyline);
      int inner_idx = static_cast<int>(std::distance(inners.begin(), it));
      treemap.push_back({p_idx, inner_idx});
    } else {
      treemap.push_back({-1, -1});
    }
  }
  return treemap;
}

void Tile::adopt(Tile* other) {
  for (ShapePool* pool : other->shapes_pools) {
    this->shapes_pools.push_back(pool);
  }
  other->shapes_pools.clear();
}
