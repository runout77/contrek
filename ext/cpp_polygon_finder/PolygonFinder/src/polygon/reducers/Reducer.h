/*
 * Reducer.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <list>
#include <vector>
#include "../finder/Node.h"

struct Point;
class Reducer {
 public:
  explicit Reducer(std::vector<Point*>& list_of_points);
  virtual void reduce();
 protected:
  std::vector<Point*> &points;
};
