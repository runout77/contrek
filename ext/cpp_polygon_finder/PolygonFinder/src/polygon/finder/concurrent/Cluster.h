/*
 * Cluster.h
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <vector>
#include <deque>
#include "Finder.h"
#include "Cluster.h"
#include "Hub.h"
#include "PartPool.h"

class Cluster {
 private:
  Finder *finder;
  std::vector<Tile*> tiles_;
  Hub *hub_ = nullptr;
 public:
  Cluster(Finder *finder, int height, int start_x, int end_x);
  virtual ~Cluster();
  void add(Tile* tile);
  Tile* merge_tiles();
  const std::vector<Tile*> tiles() const { return tiles_; }
  Hub* hub() { return hub_; }
  static void list_to_string(std::vector<Point*> list);
  PartPool parts_pool;
  std::deque<Position> positions_pool;
};
