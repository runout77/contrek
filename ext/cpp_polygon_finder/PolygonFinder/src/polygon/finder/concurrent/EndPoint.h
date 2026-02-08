/*
 * EndPoint.h
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <vector>
#include "Part.h"

class Part;

class EndPoint {
 public:
  EndPoint() : point_(nullptr) {}

  void set_point(Point* p) { point_ = p; }
  Point* get_point() const { return point_; }
  std::vector<Queueable<Point>*>& queues() { return queues_; }
  bool queues_include(Queueable<Point>* q) const;
 private:
  Point* point_;
  std::vector<Queueable<Point>*> queues_;
};
