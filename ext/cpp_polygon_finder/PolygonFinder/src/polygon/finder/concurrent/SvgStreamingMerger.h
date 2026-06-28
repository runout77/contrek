/*
 * SvgStreamingMerger.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <string>
#include <vector>
#include "StreamingMerger.h"

class SvgStreamingMerger : public StreamingMerger {
 private:
  int total_width;
  int total_height;
  std::string svg_css() {
      return ".out{fill:none;stroke:red;stroke-width:1;}.in{fill:none;stroke:green;stroke-width:1;}.out:hover{stroke:yellow;}";
  }

 protected:
  void write_header() override {
    *stream << "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"" << total_width
            << "\" height=\"" << total_height << "\"><style>" << svg_css() << "</style>";
  }
  void write_footer() override {
    *stream << "</svg>";
  }
  void write_outer_polygon_start() override {
    *stream << "<polygon points=\"";
  }
  void write_outer_polygon_end() override {
    *stream << "\" class=\"out\"/>";
  }
  void write_inner_polygon_start() override {
    *stream << "<polygon points=\"";
  }
  void write_inner_polygon_end() override {
    *stream << "\" class=\"in\"/>";
  }

 public:
  SvgStreamingMerger(int number_of_threads,
                     std::vector<std::string>* options,
                     std::ofstream* stream_to,
                     int total_width, int total_height)
    : StreamingMerger(number_of_threads, options, stream_to),
      total_width(total_width),
      total_height(total_height) {
    if (total_width <= 0 || total_height <= 0) {
      throw std::invalid_argument("SVG Streaming requires valid canvas dimensions (width and height must be > 0).");
    }
  }
};
