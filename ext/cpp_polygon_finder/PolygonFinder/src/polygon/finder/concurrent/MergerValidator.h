/*
 * MergerValidator.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once

#include <vector>
#include <list>
#include "../PolygonFinder.h"

class Merger;

class MergerValidator {
 public:
  explicit MergerValidator(const Merger& merger);

  void validate_metadata(const ProcessResult& result) const;
  void validate(const ProcessResult& result, int start_x, int end_x);

 private:
  const Merger& merger_;
  std::vector<int> previous_boundary_;
  bool has_previous_boundary_ = false;

  void validate_bounds(const std::list<Polygon>& polygons) const;
  void validate_polygon_order(const std::list<Polygon>& polygons) const;
  void validate_boundary(const ProcessResult& result, int start_x) const;

  static std::vector<int> boundary_coordinates(const std::list<Polygon>& polygons, int boundary_x);
};
