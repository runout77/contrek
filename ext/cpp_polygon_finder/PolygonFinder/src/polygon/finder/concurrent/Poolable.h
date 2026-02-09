/*
 * Poolable.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <vector>
#include <thread>
#include <queue>
#include <functional>
#include <mutex>
#include <condition_variable>
#include <atomic>
#include <utility>

class Poolable {
 public:
  // 0 (synch), -1 (maximum availables), or N thread
  explicit Poolable(int number_of_threads);
  ~Poolable();

  template<typename Payload, typename F>
  void enqueue(Payload payload, F&& func) {
    if (number_of_threads_ > 0) {
      {
        std::unique_lock<std::mutex> lock(queue_mutex);
        tasks.emplace([payload = std::move(payload), fn = std::forward<F>(func)]() mutable {
            fn(payload);
        });
      }
      condition.notify_one();
    } else {
        func(payload);  // 0 thread
    }
  }
  void wait();

 private:
  std::vector<std::thread> workers;
  std::queue<std::function<void()>> tasks;

  std::mutex queue_mutex;
  std::condition_variable condition;
  std::condition_variable wait_cv;

  int number_of_threads_;
  bool stop = false;
  std::atomic<int> active_tasks{0};
};
