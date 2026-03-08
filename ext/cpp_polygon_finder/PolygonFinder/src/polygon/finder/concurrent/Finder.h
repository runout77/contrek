/*
 * Finder.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
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
  Tile* whole_tile = nullptr;
  std::queue<ClippedPolygonFinder*> finders;
  std::mutex finders_mutex;
  std::map<std::string, double> reports;
  CpuTimer cpu_timer;

 protected:
  Queue<Tile*> tiles;
  int maximum_width_;
  int height = 0;
  void process_tiles();

 public:
  using Poolable::Poolable;
  Finder(int number_of_threads, Bitmap *bitmap, Matcher *matcher, std::vector<std::string> *options);
  Finder(int number_of_threads, std::vector<std::string> *options);
  virtual ~Finder();
  int maximum_width() const { return maximum_width_; }
  virtual ProcessResult* process_info();
};
