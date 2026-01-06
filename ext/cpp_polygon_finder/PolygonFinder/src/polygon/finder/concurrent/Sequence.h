/*
 * Sequence.h
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <string>
#include "Queueable.h"
#include "../Node.h"
#include "Position.h"

class Sequence : public Queueable<Point>{
 public:
  Sequence() {}
  std::string toString();
  bool is_not_vertical();
};
