/*
 * Queue.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <queue>
#include <mutex>
#include <condition_variable>
#include <utility>

template <typename T>
class Queue {
 public:
  void queue_push(T value) {
    std::lock_guard<std::mutex> lock(mutex_);
    queue_.push(value);
    cond_.notify_one();
    this->size_++;
  }

  T queue_pop() {
    std::unique_lock<std::mutex> lock(mutex_);
    cond_.wait(lock, [this]{ return !queue_.empty(); });
    T value = queue_.front();
    queue_.pop();
    this->size_--;
    return value;
  }

  int size() { return this->size_; }

 private:
  int size_ = 0;
  std::queue<T> queue_;
  std::mutex mutex_;
  std::condition_variable cond_;
};
