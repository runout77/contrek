/*
 * PartPool.cpp
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include "PartPool.h"
#include "Part.h"
#include "Polyline.h"

Part* PartPool::acquire(uint32_t type, Polyline* poly) {
  storage.emplace_back(static_cast<Part::Types>(type), poly);

  Part* p = &storage.back();
  p->next = nullptr;
  p->prev = nullptr;
  return p;
}

void PartPool::clear() {
  storage.clear();
}
