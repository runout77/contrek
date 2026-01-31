/*
 * Hub.h
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
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
