/*
 * GeoJsonStreamingMerger.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include "StreamingMerger.h"
#include <vector>

class GeoJsonStreamingMerger : public StreamingMerger {
private:
  unsigned int target_value;
  bool is_first_feature = true; 

protected:
  void write_header() override {
    if (stream) {
      *stream << "{\"type\":\"FeatureCollection\",\"features\":[\n";
    }
  }

  void write_footer() override {
    if (stream) {
      *stream << "\n]}";
    }
  }
  void write_outer_polygon_start() override {}
  void write_outer_polygon_end() override {}
  void write_inner_polygon_start() override {}
  void write_inner_polygon_end() override {}

public:
  GeoJsonStreamingMerger(int number_of_threads,
                         std::vector<std::string>* options,
                         std::ofstream* stream_to,
                         int total_width, int total_height,
                         unsigned int pixel_value)
      : StreamingMerger(number_of_threads, options, stream_to, total_width, total_height),
        target_value(pixel_value) {}

  void stream_raw_polygon(const Shape* shape) override {
    if (!stream) return;
    if (!is_first_feature) {
      *stream << ",\n";
    }
    is_first_feature = false;

    *stream << "{\"type\":\"Feature\",\"properties\":{\"value\":" << target_value 
            << "},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[ [";
    const std::vector<Point>& points = shape->outer_polyline->raw();
    const size_t points_size = points.size();
    if (points_size > 0) {
      for (size_t i = 0; i < points_size; ++i) {
        *stream << "[" << points[i].y << "," << points[i].x << "]";
        if (i < points_size - 1) *stream << ",";
      }
      *stream << ",[" << points[0].y << "," << points[0].x << "]]";
    } else {
      *stream << "]]";
    }

    for (const auto& inner_polyline : shape->inner_polylines) {
      const std::vector<Point>& inner_points = inner_polyline->raw();
      const size_t inner_size = inner_points.size();
      if (inner_size > 0) {
        *stream << ",[";
        for (size_t i = 0; i < inner_size; ++i) {
          *stream << "[" << inner_points[i].y << "," << inner_points[i].x << "]";
          if (i < inner_size - 1) *stream << ",";
        }
        *stream << ",[" << inner_points[0].y << "," << inner_points[0].x << "]]";
      }
    }
    *stream << "]}}";
  }
};
