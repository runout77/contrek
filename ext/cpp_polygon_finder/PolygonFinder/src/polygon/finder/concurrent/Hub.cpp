/*
 * Hub.cpp
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include "Hub.h"
#include <cstring>

Hub::Hub(int height, int start_x, int end_x)
    : width_(end_x - start_x), height_(height), start_x_(start_x)
{ size_t total_pixels = static_cast<size_t>(width_) * height;
  payloads_.resize(total_pixels);
  bitset_.resize((total_pixels + 63) / 64, 0);
  std::memset(bitset_.data(), 0, bitset_.size() * sizeof(uint64_t));
}

int Hub::spawn_end_point() {
  endpoint_pool_.emplace_back();
  return static_cast<int>(endpoint_pool_.size() - 1);
}
