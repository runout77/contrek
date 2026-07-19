/*
 * DouglasPeuckerReducer.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "DouglasPeuckerReducer.h"
#include <cstdint>
#include <limits>
#include <vector>

DouglasPeuckerReducer::DouglasPeuckerReducer(std::vector<Point>& list_of_points)
  : Reducer(list_of_points) {
}

void DouglasPeuckerReducer::reduce() {
  const std::size_t count = points.size();
  if (count < 4) {
    return;
  }
  const std::size_t first_index = extremeIndexByX();
  const std::size_t second_index = farthestIndexFrom(first_index);
  if (second_index == first_index) {
    return;
  }
  std::vector<bool> keep(count, false);
  keep[first_index] = true;
  keep[second_index] = true;
  simplifyArc(first_index, second_index, keep);
  simplifyArc(second_index, first_index, keep);
  compactRing(keep);
}

std::size_t DouglasPeuckerReducer::extremeIndexByX() const {
  std::size_t best = 0;
  int best_x = points[0].x;
  for (std::size_t index = 1; index < points.size(); ++index) {
    const int x = points[index].x;
    if (x < best_x) {
      best_x = x;
      best = index;
    }
  }
  return best;
}

std::size_t DouglasPeuckerReducer::farthestIndexFrom(std::size_t origin_index) const {
  const Point& origin = points[origin_index];
  std::size_t best_index = origin_index;
  std::int64_t best_distance = -1;
  for (std::size_t index = 0; index < points.size(); ++index) {
    const std::int64_t dx = static_cast<std::int64_t>(points[index].x) - origin.x;
    const std::int64_t dy = static_cast<std::int64_t>(points[index].y) - origin.y;
    const std::int64_t distance = dx * dx + dy * dy;
    if (distance > best_distance) {
      best_distance = distance;
      best_index = index;
    }
  }
  return best_index;
}

void DouglasPeuckerReducer::simplifyArc(std::size_t first_index, std::size_t last_index, std::vector<bool>& keep) const {
  const std::size_t count = points.size();
  std::vector<Arc> stack;
  stack.push_back({first_index, last_index});
  while (!stack.empty()) {
    const Arc arc = stack.back();
    stack.pop_back();
    std::size_t split_index = 0;
    if (!farthestOnArc(
          arc.first,
          arc.last,
          count,
          split_index)) {
      continue;
    }
    keep[split_index] = true;
    if (nextIndex(arc.first, count) != split_index) {
      stack.push_back({arc.first, split_index});
    }
    if (nextIndex(split_index, count) != arc.last) {
      stack.push_back({split_index, arc.last});
    }
  }
}

bool DouglasPeuckerReducer::farthestOnArc(std::size_t first_index, std::size_t last_index,
                                          std::size_t count, std::size_t& split_index) const {
  const Point& first = points[first_index];
  const Point& last = points[last_index];
  const double ax = static_cast<double>(first.x);
  const double ay = static_cast<double>(first.y);
  const double bx = static_cast<double>(last.x);
  const double by = static_cast<double>(last.y);
  const double abx = bx - ax;
  const double aby = by - ay;
  const double length_squared = abx * abx + aby * aby;
  double max_distance = TOLERANCE_SQUARED;
  bool found = false;
  std::size_t index = nextIndex(first_index, count);

  while (index != last_index) {
    const Point& point = points[index];
    double distance;
    if (length_squared == 0.0) {
      const double dx = static_cast<double>(point.x) - ax;
      const double dy = static_cast<double>(point.y) - ay;
      distance = dx * dx + dy * dy;
    } else {
      distance = pointSegmentDistanceSquared(
        static_cast<double>(point.x),
        static_cast<double>(point.y),
        ax,
        ay,
        bx,
        by,
        abx,
        aby,
        length_squared);
    }
    if (distance > max_distance) {
      max_distance = distance;
      split_index = index;
      found = true;
    }
    index = nextIndex(index, count);
  }
  return found;
}

double DouglasPeuckerReducer::pointSegmentDistanceSquared(
  double px,
  double py,
  double ax,
  double ay,
  double bx,
  double by,
  double abx,
  double aby,
  double length_squared) {
  const double apx = px - ax;
  const double apy = py - ay;
  const double dot = apx * abx + apy * aby;
  if (dot <= 0.0) {
    return apx * apx + apy * apy;
  }
  if (dot >= length_squared) {
    const double bpx = px - bx;
    const double bpy = py - by;
    return bpx * bpx + bpy * bpy;
  }
  const double cross = apx * aby - apy * abx;
  return (cross * cross) / length_squared;
}

std::size_t DouglasPeuckerReducer::nextIndex(std::size_t index, std::size_t count) {
  return index + 1 == count ? 0 : index + 1;
}

void DouglasPeuckerReducer::compactRing(const std::vector<bool>& keep) {
  std::size_t write_index = 0;
  for (
    std::size_t read_index = 0;
    read_index < points.size();
    ++read_index
  ) {
    if (keep[read_index]) {
      points[write_index] = points[read_index];
      ++write_index;
    }
  }
  points.resize(write_index);
}
