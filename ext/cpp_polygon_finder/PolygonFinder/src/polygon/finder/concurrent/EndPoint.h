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
  EndPoint() {}
  std::vector<Queueable<Point>*>& queues() { return queues_; }
  bool queues_include(Queueable<Point>* q) const;
 private:
  std::vector<Queueable<Point>*> queues_;
};
