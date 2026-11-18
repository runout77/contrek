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
#include <stdexcept>
#include <cstdint>
#include <charconv>
#include <system_error>
#include <fstream>

#include "StreamingMerger.h"

class GeoJsonStreamingMerger : public StreamingMerger {
 private:
  unsigned int target_value;
  bool is_first_feature = true;
  bool use_geo_localization = false;

  double x_origin = 0.0;
  double y_origin = 0.0;
  double x_pixel_size = 1.0;
  double y_pixel_size = 1.0;
  double x_row_offset = 0.0;
  double y_column_offset = 0.0;

  void configure_geo(const Options& options) {
    const Options* geo_localization = options.get_options("geo_localization");
    if (!geo_localization) {
      use_geo_localization = false;
      return;
    }

    const Options* transform = geo_localization->get_options("transform");
    const Options* crs = geo_localization->get_options("crs");
    if (!transform || !crs) {
      throw std::invalid_argument("Invalid geo_localization.");
    }

    const std::string authority = crs->get<std::string>("authority", "");
    const auto code = crs->get("code", std::int64_t{0});
    if (authority != "EPSG" || code <= 0) {
      throw std::invalid_argument("Unsupported CRS: " + authority + ":" + std::to_string(code));
    }

    x_origin = transform->get<double>("x_origin", 0.0);
    y_origin = transform->get<double>("y_origin", 0.0);
    x_pixel_size = transform->get<double>("x_pixel_size", 1.0);
    y_pixel_size = transform->get<double>("y_pixel_size", 1.0);
    x_row_offset = transform->get<double>("x_row_offset", 0.0);
    y_column_offset = transform->get<double>("y_column_offset", 0.0);
    use_geo_localization = true;
  }

  void write_point(const Point& point) {
    if (!stream) return;

    if (!use_geo_localization) {
      char buffer[128];
      char* ptr = buffer;
      char* const end = buffer + sizeof(buffer);
      *ptr++ = '[';

      auto r1 = std::to_chars(ptr, end, point.y);
      if (r1.ec != std::errc{}) throw std::runtime_error("Failed to format pixel x coordinate");
      ptr = r1.ptr;
      *ptr++ = ',';

      auto r2 = std::to_chars(ptr, end, point.x);
      if (r2.ec != std::errc{}) throw std::runtime_error("Failed to format pixel y coordinate");
      ptr = r2.ptr;
      *ptr++ = ']';

      stream->write(buffer, static_cast<std::streamsize>(ptr - buffer));
      return;
    }

    const double x = point.y;
    const double y = point.x;
    const double geo_x = x_origin + x * x_pixel_size + y * x_row_offset;
    const double geo_y = y_origin + x * y_column_offset + y * y_pixel_size;

    char buffer[128];
    char* ptr = buffer;
    char* const end = buffer + sizeof(buffer);
    *ptr++ = '[';

    auto r1 = std::to_chars(ptr, end, geo_x, std::chars_format::fixed, 7);
    if (r1.ec != std::errc{}) {
      throw std::runtime_error("Failed to format geo x coordinate");
    }

    ptr = r1.ptr;
    *ptr++ = ',';

    auto r2 = std::to_chars(ptr, end, geo_y, std::chars_format::fixed, 7);
    if (r2.ec != std::errc{}) {
      throw std::runtime_error("Failed to format geo y coordinate");
    }

    ptr = r2.ptr;
    *ptr++ = ']';
    stream->write(buffer, static_cast<std::streamsize>(ptr - buffer));
  }

 protected:
  void write_header() override {
    if (stream) *stream << "{\"type\":\"FeatureCollection\",\"features\":[";
  }

  void write_footer() override {
    if (stream) *stream << "]}";
  }

  void write_outer_polygon_start() override {}
  void write_outer_polygon_end() override {}
  void write_inner_polygon_start() override {}
  void write_inner_polygon_end() override {}

 public:
  GeoJsonStreamingMerger(int number_of_threads, const Options& options, std::ofstream* stream_to)
      : StreamingMerger(number_of_threads, options, stream_to) {
    configure_geo(options);
  }

  void stream_raw_polygon(const Polygon& polygon) override {
    if (!stream) return;

    if (!is_first_feature) *stream << ",";
    is_first_feature = false;

    *stream << "{\"type\":\"Feature\",\"properties\":{\"PixelVal\":";
    char class_buffer[32];
    auto class_result = std::to_chars(class_buffer, class_buffer + sizeof(class_buffer), polygon.class_id);
    if (class_result.ec != std::errc{}) throw std::runtime_error("Failed to format PixelVal");
    stream->write(class_buffer, static_cast<std::streamsize>(class_result.ptr - class_buffer));
    *stream << "},\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[";

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
