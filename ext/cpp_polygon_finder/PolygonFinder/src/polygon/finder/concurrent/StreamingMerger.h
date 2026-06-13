/*
 * StreamingMerger.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include "VerticalMerger.h"
#include <fstream>
#include <string>
#include <string_view>
#include <stdexcept>
#include <vector>

class StreamingMerger : public VerticalMerger {
 private:
  std::ofstream* stream;
  int total_width;
  int total_height;
  int moved = 0;
  void ensure_header();
  void ensure_footer();
  void stream_polygons(Tile* tile, bool flush = false);
  void stream_raw_polygon(const Shape* shape);
  virtual std::string svg_css();
  virtual std::string svg_header_string();
  virtual std::string svg_footer_string();
  virtual std::string svg_outer_polygon_string(std::string_view points);
  virtual std::string svg_inner_polygon_string(std::string_view points);

 public:
  StreamingMerger(int number_of_threads,
                  std::vector<std::string>* options,
                  std::ofstream* stream_to,
                  int total_width, int total_height);
  void add_tile(ProcessResult& result, bool flush = false);
  ProcessResult* process_info() override;
};
