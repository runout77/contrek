/*
 * Partitionable.h
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <vector>
#include <utility>
#include "Part.h"

class Partitionable {
 public:
  explicit Partitionable() {}
  virtual ~Partitionable() = default;
  void partition();
  Part* find_first_part_by_position(Position* position);
  std::pair<
    std::vector<std::vector<Point*>>,
    std::vector<std::vector<Point*>>> sew(std::vector<Point*> intersection, Polyline* other);

 protected:
  std::vector<Part*> parts_;

 private:
  void add_part(Part* new_part);
  void trasmute_parts();
};
