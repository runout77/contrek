/*
 * Sequence.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <string>
#include "Sequence.h"

std::string Sequence::toString() {
  std::string retme = "";
  this->each([&](QNode<Point>* pos) -> bool {
    retme += pos->payload->toString();
    return true;
  });
  return(retme);
}

bool Sequence::is_not_vertical()
{ if (this->size < 2) {
    return false;
  }
  int x0 = head->payload->x;
  this->rewind();

  while (QNode<Point>* position = this->iterator())
  { if (position->payload->x != x0) {
      return true;
    }
    this->forward();
  }
  return false;
}

void Sequence::compute_vertical_bounds()
{ const auto& cache = get_vector_cache();
  if (!cache.empty()) {
    int min_y = cache[0]->y;
    int max_y = cache[0]->y;
    for (const auto& pos : cache) {
      if (pos->y < min_y) min_y = pos->y;
      if (pos->y > max_y) max_y = pos->y;
    }
    vertical_bounds.min = min_y;
    vertical_bounds.max = max_y;
  }
}
