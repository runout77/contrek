/*
 * Sequence.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <string>
#include <vector>
#include "Queueable.h"
#include "../Node.h"
#include "Position.h"
#include "../Primitives.h"

class Shape;
class Sequence : public Queueable<Point>{
 public:
  Sequence() {}
  std::string toString();
  Shape* shape = nullptr;
};
