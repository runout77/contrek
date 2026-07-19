/*
 * RasterReducer.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "RasterReducer.h"
#include <stdexcept>
#include <string>

RasterReducer::RasterReducer(std::vector<Point>& points, int versus)
  : Reducer(points),
    versus_(versus) {
}

void RasterReducer::reduce() {
  toRasterPolygon(points, versus_);
}

void RasterReducer::toRasterPolygon(std::vector<Point>& points, int versus) {
  const std::size_t n = points.size();

  if (n == 0) {
      return;
  }

  const bool outer = versus == Node::O;
  const int firstX = points.front().x;
  const int firstY = points.front().y;
  int previousX = points.back().x;
  int previousY = points.back().y;

  for (std::size_t i = 0; i < n; ++i) {
    const int currentX = points[i].x;
    const int currentY = points[i].y;
    int nextX;
    int nextY;
    if (i + 1 < n) {
      nextX = points[i + 1].x;
      nextY = points[i + 1].y;
    } else {
      nextX = firstX;
      nextY = firstY;
    }
    const Pole incomingSide = segmentPole(
      currentX - previousX,
      currentY - previousY,
      outer);
    const Pole outgoingSide = segmentPole(
      nextX - currentX,
      nextY - currentY,
      outer);
    int x = currentX;
    int y = currentY;
    const auto applySide = [&x, &y](Pole side) {
      switch (side) {
        case Pole::South:
          --y;
          break;

        case Pole::East:
          --x;
          break;

        case Pole::North:
        case Pole::West:
          break;
      }
    };
    applySide(incomingSide);
    if (outgoingSide != incomingSide) {
      applySide(outgoingSide);
    }
    points[i].x = x;
    points[i].y = y;
    previousX = currentX;
    previousY = currentY;
  }
}

RasterReducer::Pole RasterReducer::segmentPole(int dx, int dy, bool clockwise) {
  const int sx = sign(dx);
  const int sy = sign(dy);
  if (sx == 0 && sy == 1) {
    return clockwise ? Pole::East : Pole::West;
  }
  if (sx == 1 && sy == 0) {
    return clockwise ? Pole::North : Pole::South;
  }
  if (sx == 0 && sy == -1) {
    return clockwise ? Pole::West : Pole::East;
  }
  if (sx == -1 && sy == 0) {
    return clockwise ? Pole::South : Pole::North;
  }
  throw std::invalid_argument(
    "Non-axial segment dx=" +
    std::to_string(dx) +
    " dy=" +
    std::to_string(dy) +
    "!");
}

int RasterReducer::sign(int value) {
  return (value > 0) - (value < 0);
}
