/*
 * SubPool.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <deque>
#include <memory>
#include <utility>

class ShapePool;

template <typename T>
class SubPool {
 private:
  std::unique_ptr<std::deque<T>> storage_;
  uint32_t active_count_ = 0;
  ShapePool* macro_pool_ = nullptr;

 public:
  explicit SubPool(ShapePool* macro_pool) : macro_pool_(macro_pool) {
    storage_ = std::make_unique<std::deque<T>>();
  }

  template <typename... Args>
  T* acquire(Args&&... args) {
    storage_->emplace_back(std::forward<Args>(args)...);
    T* ptr = &storage_->back();
    active_count_++;
    return ptr;
  }

  void decrement() {
    active_count_--;
    if (active_count_ == 0 && storage_ != nullptr) {
      storage_.reset();
    }
  }

  bool is_released() const {
    return storage_ == nullptr;
  }
};
