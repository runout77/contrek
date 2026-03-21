/*
 * PointPool.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "PointPool.h"

Point* PointPool::acquire(int x, int y) {
  storage.emplace_back(x, y);
  return &storage.back();
}

void PointPool::clear() {
  storage.clear();
}
