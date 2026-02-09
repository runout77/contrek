/*
 * PartPool.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <deque>
#include <cstdint>  // for uint32_t

class Part;
class Polyline;

class PartPool {
 private:
  std::deque<Part> storage;

 public:
  Part* acquire(uint32_t type, Polyline* poly);
  void clear();
};
