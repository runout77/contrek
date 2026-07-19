/*
 * DouglasPeuckerReducer.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <cstddef>
#include <vector>
#include "Reducer.h"

struct Point;

class DouglasPeuckerReducer : public Reducer {
 public:
  explicit DouglasPeuckerReducer(std::vector<Point>& list_of_points);
  void reduce() override;

 private:
  static constexpr double TOLERANCE_SQUARED = 1.0;
  struct Arc {
    std::size_t first;
    std::size_t last;
  };
  std::size_t extremeIndexByX() const;
  std::size_t farthestIndexFrom(
    std::size_t origin_index) const;
  void simplifyArc(
    std::size_t first_index,
    std::size_t last_index,
    std::vector<bool>& keep) const;
  bool farthestOnArc(
    std::size_t first_index,
    std::size_t last_index,
    std::size_t count,
    std::size_t& split_index) const;
  static double pointSegmentDistanceSquared(
    double px,
    double py,
    double ax,
    double ay,
    double bx,
    double by,
    double abx,
    double aby,
    double length_squared);
  static std::size_t nextIndex(std::size_t index, std::size_t count);
  void compactRing(const std::vector<bool>& keep);
};
