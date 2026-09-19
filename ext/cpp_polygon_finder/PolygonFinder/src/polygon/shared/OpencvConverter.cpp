/*
 * OpencvConverter.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "OpencvConverter.h"

#include <algorithm>
#include <functional>
#include <limits>
#include <utility>
#include <vector>

std::size_t OpencvConverter::EdgeKeyHash::operator()(const EdgeKey& key) const {
  return std::hash<uint64_t>{}(key.a) ^
         (std::hash<uint64_t>{}(key.b) << 1);
}

uint64_t OpencvConverter::point_key(const Point& p) {
  return (static_cast<uint64_t>(static_cast<uint32_t>(p.x)) << 32) |
         static_cast<uint32_t>(p.y);
}

OpencvConverter::EdgeKey OpencvConverter::edge_key(const Point& a, const Point& b) {
  uint64_t ka = point_key(a);
  uint64_t kb = point_key(b);
  if (ka > kb) {
    std::swap(ka, kb);
  }
  return {ka, kb};
}

void OpencvConverter::rotate_to_scanline_start(std::vector<Point>& points, const RectBounds& bounds) {
  if (points.empty()) return;

  std::size_t index = points.size();
  int min_x = std::numeric_limits<int>::max();
  for (std::size_t i = 0; i < points.size(); ++i) {
    if (points[i].y == bounds.min_y && points[i].x < min_x) {
      min_x = points[i].x;
      index = i;
    }
  }
  if (index != points.size() && index > 0) {
    std::rotate(points.begin(), points.begin() + index, points.end());
  }
}
