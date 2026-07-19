/*
 * Part.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <cstdint>
#include <string>
#include <deque>
#include <vector>
#include "Queueable.h"
#include "Position.h"
#include "EndPoint.h"
#include "../Node.h"

class Polyline;
class Position;
class EndPoint;
class Part : public Queueable<Point> {
 public:
  enum Types : uint32_t {
    SEAM = 1,
    EXCLUSIVE = 0
  };
  explicit Part(Types type, Polyline* polyline);
  bool listable() const override { return true; }
  bool is(Types type);

 private:
  bool touched_ = false;

 public:
  Part* next = nullptr;
  Part* circular_next = nullptr;
  std::string toString() const { return "Part type = " + std::to_string(static_cast<uint32_t>(type)); }
  Polyline* polyline() { return polyline_; }
  Position* next_position(Position* force_position);
  void add_position(const Point& point);
  Types type;
  bool innerable();
  bool touched() const { return touched_; }
  int versus() const { return versus_; }
  void touch();
  void orient();
  std::string inspect();

 private:
  int versus_ = 0;
  Polyline* polyline_;
};
