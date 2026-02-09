/*
 * LinearReducer.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <vector>
#include <array>
#include "Reducer.h"

class LinearReducer : public Reducer {
 public:
  explicit LinearReducer(std::vector<Point*>& list_of_points);
  void reduce();

 private:
  std::array<int, 2> seq_dir(Point *a, Point *b);
};
