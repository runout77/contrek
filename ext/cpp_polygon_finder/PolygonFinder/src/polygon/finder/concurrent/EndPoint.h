/*
 * EndPoint.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <vector>
#include <unordered_set>
#include "Part.h"

class Part;

class EndPoint {
 public:
  EndPoint() : point_(nullptr) {}

  void set_point(Point* p) { point_ = p; }
  Point* get_point() const { return point_; }
  std::vector<Queueable<Point>*>& queues() { return queues_; }
  bool queues_include(Queueable<Point>* q) const;
  bool tracked_outer = false;

 private:
  Point* point_;
  std::vector<Queueable<Point>*> queues_;
};
