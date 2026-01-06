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
  explicit Hub(int height, int width);
  EndPoint* spawn_end_point();
  const int width() const { return width_; }
  inline EndPoint* get(int key) const {
    if (!is_set(key)) return nullptr;
    return payloads_[key];
  }
  inline void put(int key, EndPoint* payload) {
    payloads_[key] = payload;
    bitset_[key >> 6] |= (1ULL << (key & 63));
  }
  inline bool is_set(int key) const {
    return (bitset_[key >> 6] & (1ULL << (key & 63)));
  }

 private:
  int width_;
  int height_;
  std::vector<EndPoint*> payloads_;
  std::deque<EndPoint> endpoint_pool_;
  Hub(const Hub&) = delete;
  Hub& operator=(const Hub&) = delete;
  std::vector<uint64_t> bitset_;
};
