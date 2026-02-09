/*
 * Partitionable.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <vector>
#include <utility>
#include <optional>
#include "Part.h"

using SewReturnData = std::pair<std::vector<std::vector<Point*>>, std::vector<std::vector<Point*>>>;

class Partitionable {
 public:
  explicit Partitionable() {}
  virtual ~Partitionable() = default;
  void partition();
  Part* find_first_part_by_position(Position* position);
  std::optional<SewReturnData> sew(std::vector<std::pair<int, int>> intersection, Polyline* other);

 protected:
  std::vector<Part*> parts_;

 private:
  void add_part(Part* new_part);
  void insert_after(Part* part, Part* new_part);
  void trasmute_parts();
};
