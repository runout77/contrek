/*
 * PartPool.h
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
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
