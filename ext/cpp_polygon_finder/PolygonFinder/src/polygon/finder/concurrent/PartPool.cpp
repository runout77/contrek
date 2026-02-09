/*
 * PartPool.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
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
