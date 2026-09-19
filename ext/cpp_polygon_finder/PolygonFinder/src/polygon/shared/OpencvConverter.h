/*
 * OpencvConverter.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once

#include <vector>
#include <unordered_map>
#include <unordered_set>
#include <cstdint>
#include <stdexcept>
#include <cstdlib>

#include "polygon/finder/Node.h"
#include "RectBounds.h"

class OpencvConverter {
 private:
  static constexpr int chain_dir[3][3] = {
    {3, 4, 5},
    {2, -1, 6},
    {1, 0, 7}
  };

  static constexpr int corner_x[4] = {0, 1, 1, 0};
  static constexpr int corner_y[4] = {1, 1, 0, 0};

  struct BoundaryEdge {
    Point a;
    Point b;
  };

  struct EdgeKey {
    uint64_t a;
    uint64_t b;
    bool operator==(const EdgeKey& other) const {
      return a == other.a && b == other.b;
    }
  };

  struct EdgeKeyHash {
    std::size_t operator()(const EdgeKey& key) const;
  };

  static uint64_t point_key(const Point& p);
  static EdgeKey edge_key(const Point& a, const Point& b);
  static void rotate_to_scanline_start(std::vector<Point>& points, const RectBounds& bounds);

  template<typename P>
  static int chain_direction(const P& from, const P& to) {
    const int dx = to.x - from.x;
    const int dy = to.y - from.y;

    if (dx == 0 && dy == 0)
      throw std::invalid_argument("Zero-length contour step");

    if (std::abs(dx) > 1 || std::abs(dy) > 1)
      throw std::invalid_argument("Non-adjacent contour step");

    return chain_dir[dx + 1][dy + 1];
  }

 public:
  template<typename P>
  static std::vector<Point> contour_to_cell_boundary(const std::vector<P>& contour, const RectBounds& bounds) {
    std::vector<Point> raw;
    const std::size_t n = contour.size();

    if (n == 0) {
      return raw;
    }

    if (n == 1) {
      const int x = contour[0].x;
      const int y = contour[0].y;
      return {
        Point(x, y + 1),
        Point(x + 1, y + 1),
        Point(x + 1, y),
        Point(x, y)
      };
    }

    raw.reserve(n * 2);

    for (std::size_t i = 0; i < n; ++i) {
      const P& previous = contour[(i + n - 1) % n];
      const P& current  = contour[i];
      const P& next     = contour[(i + 1) % n];
      const int incoming = chain_direction(previous, current);
      const int outgoing = chain_direction(current, next);
      int corner = incoming >> 1;
      const int last_corner = ((outgoing + 1) >> 1) & 3;
      for (;;) {
        raw.emplace_back(current.x + corner_x[corner], current.y + corner_y[corner]);
        if (corner == last_corner) {
          break;
        }
        corner = (corner + 1) & 3;
      }
    }

    std::vector<BoundaryEdge> edges;
    edges.reserve(raw.size());

    for (std::size_t i = 0; i < raw.size(); ++i) {
      const Point& a = raw[i];
      const Point& b = raw[(i + 1) % raw.size()];
      if (a.x == b.x && a.y == b.y) {
        continue;
      }
      edges.push_back({a, b});
    }

    std::unordered_map<EdgeKey, int, EdgeKeyHash> counts;

    for (const auto& edge : edges) {
      ++counts[edge_key(edge.a, edge.b)];
    }

    std::unordered_set<EdgeKey, EdgeKeyHash> kept;
    std::vector<BoundaryEdge> filtered;
    filtered.reserve(edges.size());

    for (const auto& edge : edges) {
      const EdgeKey key = edge_key(edge.a, edge.b);
      if (((counts[key] & 1) == 0) ||
          (kept.find(key) != kept.end())) {
        continue;
      }
      kept.insert(key);
      filtered.push_back(edge);
    }

    if (filtered.empty()) {
      return {};
    }

    std::unordered_map<uint64_t, std::vector<std::size_t>> outgoing;
    for (std::size_t i = 0; i < filtered.size(); ++i) {
      outgoing[point_key(filtered[i].a)].push_back(i);
    }

    std::vector<bool> used(filtered.size(), false);
    std::size_t used_count = 0;
    std::vector<Point> result;
    result.reserve(filtered.size());

    auto first_unused = [&]() {
      for (std::size_t i = 0; i < used.size(); ++i) {
        if (!used[i])
          return i;
      }
      return used.size();
    };

    std::size_t current = 0;

    while (used_count < filtered.size()) {
      if (used[current]) {
        current = first_unused();
        if (current == used.size()) {
          break;
        }
      }

      const BoundaryEdge& edge = filtered[current];

      used[current] = true;
      ++used_count;

      result.push_back(edge.a);

      const uint64_t finish = point_key(edge.b);

      auto it = outgoing.find(finish);
      std::size_t next_edge = filtered.size();

      if (it != outgoing.end()) {
        for (std::size_t candidate : it->second) {
          if (!used[candidate]) {
            next_edge = candidate;
            break;
          }
        }
      }

      if (next_edge != filtered.size()) {
        current = next_edge;
      } else {
        current = first_unused();
        if (current == used.size())
          break;
      }
    }

    rotate_to_scanline_start(result, bounds);
    return result;
  }
};
