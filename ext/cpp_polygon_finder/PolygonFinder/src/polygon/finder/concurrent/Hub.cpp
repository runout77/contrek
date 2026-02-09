/*
 * Hub.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "Hub.h"
#include <cstring>

Hub::Hub(int height, int start_x, int end_x)
    : width_(end_x - start_x), height_(height), start_x_(start_x)
{ size_t total_pixels = static_cast<size_t>(height);
  payloads_.resize(total_pixels);
  bitset_.resize((total_pixels + 63) / 64, 0);
  std::memset(bitset_.data(), 0, bitset_.size() * sizeof(uint64_t));
  endpoint_pool_.resize(total_pixels);
}

int Hub::spawn_end_point() {
  endpoint_pool_.emplace_back();
  return static_cast<int>(endpoint_pool_.size() - 1);
}
