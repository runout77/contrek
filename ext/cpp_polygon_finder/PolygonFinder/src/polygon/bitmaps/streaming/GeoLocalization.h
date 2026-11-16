/*
 * GeoLocalization.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once

#include <string>
#include "../finder/Options.h"

struct GeoTransform {
  double x_origin = 0.0;
  double y_origin = 0.0;
  double x_pixel_size = 1.0;
  double y_pixel_size = 1.0;
  double x_row_offset = 0.0;
  double y_column_offset = 0.0;
};

struct GeoCrs {
  std::string authority;
  int code = 0;
};

struct GeoLocalization {
  bool valid = false;
  GeoTransform transform;
  GeoCrs crs;
  Options to_options() const {
    if (!valid) {
      throw std::runtime_error("Invalid geolocalization");
    }
    return Options{
      {"transform", Options{
        {"x_origin", transform.x_origin},
        {"y_origin", transform.y_origin},
        {"x_pixel_size", transform.x_pixel_size},
        {"y_pixel_size", transform.y_pixel_size},
        {"x_row_offset", transform.x_row_offset},
        {"y_column_offset", transform.y_column_offset}
      }},
      {"crs", Options{
        {"authority", crs.authority},
        {"code", std::int64_t{crs.code}}
      }}
    };
  }
};
