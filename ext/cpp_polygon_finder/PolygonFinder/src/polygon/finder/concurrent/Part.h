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
    EXCLUSIVE = 0,
    ADDED = 2
  };
  explicit Part(Types type, Polyline* polyline);
  bool is(Types type);
  bool inverts = false;
  bool trasmuted = false;
  bool delayed = false;
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
  void set_polyline(Polyline* polyline) { this->polyline_ = polyline; }
  std::vector<EndPoint*> to_endpoints();
  static std::vector<EndPoint*> remove_adjacent_pairs(const std::vector<EndPoint*>& input);

 private:
  bool touched_ = false;
  Polyline* polyline_;
};
