/*
 * Hub.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <vector>
#include <deque>
#include "EndPoint.h"

class EndPoint;
class Hub {
 public:
  explicit Hub(int height, int start_x, int end_x);
  int spawn_end_point();
  const int width() const { return width_; }
  const int start_x() const { return start_x_; }
  inline EndPoint* get(int key) {
    if (!is_set(key)) return nullptr;
    int index = payloads_[key];
    return &endpoint_pool_[index];
  }
  inline EndPoint* put(int key, int index) {
    payloads_[key] = index;
    bitset_[key >> 6] |= (1ULL << (key & 63));
    return &endpoint_pool_[index];
  }
  inline bool is_set(int key) const {
    return (bitset_[key >> 6] & (1ULL << (key & 63)));
  }

 private:
  int width_;
  int height_;
  int start_x_;
  std::vector<int> payloads_;
  std::vector<EndPoint> endpoint_pool_;
  Hub(const Hub&) = delete;
  Hub& operator=(const Hub&) = delete;
  std::vector<uint64_t> bitset_;
};
