/*
 * Sequence.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <string>
#include <vector>
#include "Queueable.h"
#include "../Node.h"
#include "Position.h"
#include "../Primitives.h"

class Shape;
class Sequence : public Queueable<Point>{
 public:
  Sequence() {}
  std::string toString();
  bool is_not_vertical();
  Shape* shape = nullptr;
  Bounds vertical_bounds;
  void compute_vertical_bounds();
  const std::vector<Point*>& get_vector_cache() {
    if (vector_cache.empty() && this->size > 0) {
      vector_cache = this->to_vector();
    }
    return vector_cache;
  }
 private:
  std::vector<Point*> vector_cache;
};
