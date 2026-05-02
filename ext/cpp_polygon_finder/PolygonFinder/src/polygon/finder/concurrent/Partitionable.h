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
#include "Part.h"

class Partitionable {
 public:
  explicit Partitionable() {}
  virtual ~Partitionable() = default;
  void partition();
  const std::vector<Part*> parts() const { return parts_; }

 protected:
  std::vector<Part*> parts_;

 private:
  void add_part(Part* new_part);
  void trasmute_parts();
};
