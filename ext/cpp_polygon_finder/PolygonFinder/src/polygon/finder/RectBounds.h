/*
 * RectBounds.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <limits>
#include <algorithm>

struct RectBounds {
  int min_x = std::numeric_limits<int>::max();
  int max_x = std::numeric_limits<int>::min();
  int min_y = std::numeric_limits<int>::max();
  int max_y = std::numeric_limits<int>::min();

  static RectBounds empty() {
    return RectBounds{};
  }

  inline RectBounds& expand(int x, int y) {
    if (x < min_x) min_x = x;
    if (x > max_x) max_x = x;
    if (y < min_y) min_y = y;
    if (y > max_y) max_y = y;
    return *this;
  }

  inline bool is_empty() const {
    return min_x == std::numeric_limits<int>::max();
  }

  inline int width() const {
    if (is_empty()) return 0;
    return(max_x - min_x);
  }
};
