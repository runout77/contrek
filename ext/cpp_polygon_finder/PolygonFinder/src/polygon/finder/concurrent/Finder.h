/*
 * Finder.h
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <queue>
#include <mutex>
#include <string>
#include <map>
#include <vector>
#include "Poolable.h"
#include "../PolygonFinder.h"
#include "Queue.h"
#include "Tile.h"

struct TilePayload {
  int tile_index;
  int tile_start_x;
  int tile_end_x;
};

class Bitmap;
class Matcher;
class Tile;
class ClippedPolygonFinder;

class Finder : public Poolable {
 private:
  Bitmap *bitmap;
  Matcher *matcher;
  pf_Options options;
  std::vector<std::string> input_options;
  int maximum_width_;
  Queue<Tile*> tiles;
  Tile* whole_tile = nullptr;
  void process_tiles();
  std::queue<ClippedPolygonFinder*> finders;
  std::mutex finders_mutex;
  std::map<std::string, double> reports;
  CpuTimer cpu_timer;

 public:
  using Poolable::Poolable;
  Finder(int number_of_threads, Bitmap *bitmap, Matcher *matcher, std::vector<std::string> *options);
  virtual ~Finder();
  int maximum_width() const { return maximum_width_; }
  ProcessResult* process_info();
};
