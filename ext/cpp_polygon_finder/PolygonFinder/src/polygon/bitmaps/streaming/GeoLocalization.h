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
};
