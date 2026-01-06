/*
 * Queue.h
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
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
  }

  T queue_pop() {
    std::unique_lock<std::mutex> lock(mutex_);
    cond_.wait(lock, [this]{ return !queue_.empty(); });
    T value = queue_.front();
    queue_.pop();
    return value;
  }

 private:
  std::queue<T> queue_;
  std::mutex mutex_;
  std::condition_variable cond_;
};
