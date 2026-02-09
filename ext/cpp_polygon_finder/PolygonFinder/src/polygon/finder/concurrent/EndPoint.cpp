/*
 * EndPoint.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "EndPoint.h"
#include <iostream>

bool EndPoint::queues_include(Queueable<Point>* q) const {
  return (std::find(queues_.begin(), queues_.end(), q) != queues_.end());
}
