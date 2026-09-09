/*
 * GeoJsonStreamingMerger.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <vector>
#include <string>
#include <functional>
#include <stdexcept>
#include <iomanip>
#include <limits>
#include "StreamingMerger.h"

class GeoJsonStreamingMerger : public StreamingMerger {
 private:
  unsigned int target_value;
  bool is_first_feature = true;
  std::function<void(const Point&)> point_writer;

  void configure_point_writer(const Options& options) {
    const Options* geo_localization = options.get_options("geo_localization");
    if (!geo_localization) {
      point_writer = [this](const Point& point) { *stream << "[" << point.y << "," << point.x << "]"; };
      return;
    }

    const Options* transform = geo_localization->get_options("transform");
    const Options* crs = geo_localization->get_options("crs");
    if (!transform || !crs) throw std::invalid_argument("Invalid geo_localization.");

    const std::string authority = crs->get<std::string>("authority", "");
    const auto code = crs->get("code", 0L);
    if (authority != "EPSG" || code != 4326) throw std::invalid_argument("Unsupported CRS: " + authority + ":" + std::to_string(code));
    const double x_origin = transform->get<double>("x_origin", 0.0);
    const double y_origin = transform->get<double>("y_origin", 0.0);
    const double x_pixel_size = transform->get<double>("x_pixel_size", 1.0);
    const double y_pixel_size = transform->get<double>("y_pixel_size", 1.0);
    const double x_row_offset = transform->get<double>("x_row_offset", 0.0);
    const double y_column_offset = transform->get<double>("y_column_offset", 0.0);

    *stream << std::fixed << std::setprecision(7);

    point_writer = [this, x_origin, y_origin, x_pixel_size, y_pixel_size, x_row_offset, y_column_offset](const Point& point) {
      const double x = point.y;
      const double y = point.x;
      *stream << "[" << x_origin + x * x_pixel_size + y * x_row_offset << "," << y_origin + x * y_column_offset + y * y_pixel_size << "]";
    };
  }

  void write_point(const Point& point) {
    point_writer(point);
  }

 protected:
  void write_header() override {
    if (stream) {
      *stream << "{\"type\":\"FeatureCollection\",\"features\":[";
    }
  }

  void write_footer() override {
    if (stream) {
      *stream << "]}";
    }
  }
  void write_outer_polygon_start() override {}
  void write_outer_polygon_end() override {}
  void write_inner_polygon_start() override {}
  void write_inner_polygon_end() override {}

 public:
  GeoJsonStreamingMerger(int number_of_threads,
                         const Options& options,
                         std::ofstream* stream_to,
                         unsigned int pixel_value)
      : StreamingMerger(number_of_threads, options, stream_to),
        target_value(pixel_value) {
    configure_point_writer(options);
  }

  void stream_raw_polygon(const Polygon& polygon) override {
    if (!stream) return;
    if (!is_first_feature) {
      *stream << ",";
    }
    is_first_feature = false;

    *stream << "{\"type\":\"Feature\",\"properties\":{\"PixelVal\":" << target_value
            << "},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[";
    const std::vector<Point>& points = polygon.outer;
    const size_t points_size = points.size();
    if (points_size > 0) {
      for (size_t i = 0; i < points_size; ++i) {
        write_point(points[i]);
        if (i < points_size - 1) *stream << ",";
      }
      *stream << ",";
      write_point(points[0]);
      *stream << "]";
    } else {
      *stream << "]";
    }

    for (const std::vector<Point>& inner_points : polygon.inner) {
      const size_t inner_size = inner_points.size();
      if (inner_size > 0) {
        *stream << ",[";
        for (size_t i = 0; i < inner_size; ++i) {
          write_point(inner_points[i]);
          if (i < inner_size - 1) *stream << ",";
        }
        *stream << ",";
        write_point(inner_points[0]);
        *stream << "]";
      }
    }
    *stream << "]}}";
  }
};
