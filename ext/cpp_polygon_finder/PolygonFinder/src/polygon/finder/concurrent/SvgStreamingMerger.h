/*
 * SvgStreamingMerger.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include "StreamingMerger.h"
#include <string>

class SvgStreamingMerger : public StreamingMerger {
private:
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
  using StreamingMerger::StreamingMerger;
};
