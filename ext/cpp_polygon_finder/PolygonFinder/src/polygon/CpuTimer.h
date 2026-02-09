/*
 * CpuTimer.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <chrono>

class CpuTimer {
  using Clock = std::chrono::steady_clock;
  std::chrono::time_point<Clock> _start;
  bool _running = false;

 public:
  void start() {
    _start = Clock::now();
    _running = true;
  }

  double stop() {
    if (!_running) return 0.0;
    auto duration = elapsed_ms();
    _running = false;
    return duration;
  }

  double elapsed_ms() const {
    if (!_running) return 0.0;
    auto end = Clock::now();
    std::chrono::duration<double, std::milli> diff = end - _start;
    return diff.count();
  }

  void reset() {
    _running = false;
  }

  bool is_running() const {
    return _running;
  }
};
