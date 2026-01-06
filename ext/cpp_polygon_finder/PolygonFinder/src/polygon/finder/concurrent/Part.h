/*
 * Part.h
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <cstdint>
#include <string>
#include <deque>
#include "Queueable.h"
#include "Position.h"
#include "../Node.h"

class Polyline;
class Position;
class Part : public Queueable<Point> {
 public:
  enum Types : uint32_t {
    SEAM = 1,
    EXCLUSIVE = 0,
    ADDED = 2
  };
  explicit Part(Types type, Polyline* polyline);
  bool is(Types type);
  bool inverts = false;
  bool trasmuted = false;
  Part* next = nullptr;
  Part* prev = nullptr;
  Part* circular_next = nullptr;
  std::string toString() const { return "Part type = " + std::to_string(static_cast<uint32_t>(type)); }
  Polyline* polyline() { return polyline_; }
  Position* next_position(Position* force_position);
  void add_position(Point* point);
  int passes = 0;
  Types type;
  bool innerable();
  const bool touched() const { return touched_; }
  void touch();
  bool intersect_part(Part* other_part);

 private:
  bool touched_ = false;
  Polyline* polyline_;
};
