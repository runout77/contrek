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
#include "Finder.h"
#include "ClippedPolygonFinder.h"

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
  std::list<Shape*> boundary_shapes_;
  bool boundary_shapes_initialized_ = false;
  void assign_raw_polygons(const std::list<Polygon>& raw_polylines);

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
  const std::list<Shape*>& boundary_shapes();
  bool whole();
  bool left();
  bool right();
  void initial_process(ClippedPolygonFinder *finder);
  void info();
  bool tg_border(const Point& coord);
  void assign_shapes(std::list<Shape*>& shapes);
  std::list<Polygon> to_raw_polygons();
  Benchmarks benchmarks;
};
