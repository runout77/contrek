/*
 * Poolable.cpp
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include <utility>
#include "Poolable.h"

Poolable::Poolable(int number_of_threads) : stop(false) {
  if (number_of_threads == -1) {
    number_of_threads_ = static_cast<int>(std::thread::hardware_concurrency());
  } else {
    number_of_threads_ = number_of_threads;
  }

  for (int i = 0; i < number_of_threads_; ++i) {
    workers.emplace_back([this] {
      while (true) {
        std::function<void()> task;
        {
          std::unique_lock<std::mutex> lock(this->queue_mutex);
          this->condition.wait(lock, [this] {
              return this->stop || !this->tasks.empty();
          });

          if (this->stop && this->tasks.empty()) return;

          task = std::move(this->tasks.front());
          this->tasks.pop();
          active_tasks++;
        }
        task();
        active_tasks--;
        wait_cv.notify_all();
      }
    });
  }
}

Poolable::~Poolable() {
  {
    std::unique_lock<std::mutex> lock(queue_mutex);
    stop = true;
  }
  condition.notify_all();
  for (std::thread &worker : workers) {
      if (worker.joinable()) worker.join();
  }
}

void Poolable::wait() {
  std::unique_lock<std::mutex> lock(queue_mutex);
  wait_cv.wait(lock, [this] {
      return tasks.empty() && active_tasks == 0;
  });
}
