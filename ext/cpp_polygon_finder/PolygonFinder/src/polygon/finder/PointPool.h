/*
 * PointPool.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <deque>
#include <cstdint>
#include <string>
#include "Node.h"

class PointPool {
 private:
  std::deque<Point> storage;

 public:
  Point* acquire(int x, int y);
  void clear();
  size_t size() const { return storage.size(); }
};
