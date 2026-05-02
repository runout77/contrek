/*
 * Tile.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <string>
#include <list>
#include <vector>
#include "Finder.h"
#include "ClippedPolygonFinder.h"
#include "ShapePool.h"

class Finder;
class Cluster;
class Shape;

struct Benchmarks {
  double outer;
  double inner;
};

class Tile {
 private:
  Finder *finder;
  int start_x_;
  int end_x_;
  std::string name_;
  std::list<Shape*> shapes_;

 public:
  Tile(Finder *finder, int start_x, int end_x, std::string name, const Benchmarks& b);
  virtual ~Tile();
  Tile *prev = nullptr;
  Tile *next = nullptr;
  Tile* circular_next = nullptr;
  Cluster *cluster = nullptr;
  int start_x() const { return start_x_; }
  int end_x() const { return end_x_; }
  std::string name() const { return name_; }
  const std::list<Shape*>& shapes() const { return shapes_; }
  std::list<Shape*>& shapes() { return shapes_; }
  bool whole();
  bool left();
  bool right();
  void initial_process(ClippedPolygonFinder *finder);
  void info();
  bool tg_border(const Point& coord);
  void assign_shapes(std::list<Shape*>& shapes);
  void assign_raw_polygons(const std::list<Polygon>& raw_polylines, const std::vector<std::pair<int, int>>& treemap);
  std::list<Polygon> to_raw_polygons();
  std::vector<std::pair<int, int>> compute_treemap();
  std::string toString();
  Benchmarks benchmarks;
  std::vector<ShapePool*> shapes_pools;
  ShapePool* shapes_pool;
  void adopt(Tile* other);
};
