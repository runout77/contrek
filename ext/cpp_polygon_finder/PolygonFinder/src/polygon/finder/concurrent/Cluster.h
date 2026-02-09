/*
 * Cluster.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
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
