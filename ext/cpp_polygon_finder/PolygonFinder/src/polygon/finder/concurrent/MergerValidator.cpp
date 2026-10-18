/*
 * MergerValidator.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "MergerValidator.h"
#include "Merger.h"
#include <algorithm>
#include <stdexcept>
#include <vector>
#include <list>
#include <utility>

MergerValidator::MergerValidator(const Merger& merger)
  : merger_(merger) {}

void MergerValidator::validate_metadata(const ProcessResult& result) const {
  if (result.width <= 0) {
    throw std::invalid_argument("Invalid result metadata: width must be a positive integer");
  }
  if (result.height <= 0) {
    throw std::invalid_argument("Invalid result metadata: height must be a positive integer");
  }
  if (result.versus != Node::A && result.versus != Node::O) {
    throw std::invalid_argument("Invalid result metadata: unsupported versus option");
  }
}

void MergerValidator::validate(const ProcessResult& result, int start_x, int end_x) {
  validate_bounds(result.polygons);
  validate_polygon_order(result.polygons);
  validate_boundary(result, start_x);

  previous_boundary_ = boundary_coordinates(result.polygons, end_x);
  has_previous_boundary_ = true;
}

void MergerValidator::validate_bounds(const std::list<Polygon>& polygons) const {
  for (const auto& polygon : polygons) {
    if (polygon.outer.empty()) {
      throw std::invalid_argument("Invalid polygon: empty outer contour");
    }
    RectBounds actual = RectBounds::empty();

    for (const auto& point : polygon.outer) {
      actual.expand(point.x, point.y);
    }

    const auto& bounds = polygon.bounds;
    if (bounds.min_x != actual.min_x ||
        bounds.max_x != actual.max_x ||
        bounds.min_y != actual.min_y ||
        bounds.max_y != actual.max_y) {
      throw std::invalid_argument("Invalid polygon bounds: bounding box does not match outer contour");
    }
  }
}

void MergerValidator::validate_polygon_order(const std::list<Polygon>& polygons) const {
  bool has_previous = false;
  std::pair<int, int> previous;

  for (const auto& polygon : polygons) {
    const auto& bounds = polygon.bounds;

    const std::pair<int, int> current = merger_.transpose()
      ? std::make_pair(bounds.min_x, bounds.min_y)
      : std::make_pair(bounds.min_y, bounds.min_x);

    if (has_previous && current < previous) {
      throw std::invalid_argument("Invalid polygon order: polygons are not in raster scan order");
    }
    previous = current;
    has_previous = true;
  }
}

void MergerValidator::validate_boundary(const ProcessResult& result, int start_x) const {
  if (!has_previous_boundary_) return;

  const auto current = boundary_coordinates(result.polygons, start_x);
  if (previous_boundary_ != current) {
    throw std::invalid_argument("Tile boundary mismatch: adjacent tiles have different edge coordinates");
  }
}

std::vector<int> MergerValidator::boundary_coordinates(const std::list<Polygon>& polygons, int boundary_x) {
  std::vector<int> coordinates;

  for (const auto& polygon : polygons) {
    for (const auto& point : polygon.outer) {
      if (point.x == boundary_x) {
        coordinates.push_back(point.y);
      }
    }
  }

  std::sort(coordinates.begin(), coordinates.end());
  return coordinates;
}
