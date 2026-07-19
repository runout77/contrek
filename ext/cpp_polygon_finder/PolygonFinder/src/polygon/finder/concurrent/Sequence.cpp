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
    retme += pos->payload.toString();
    return true;
  });
  return(retme);
}
