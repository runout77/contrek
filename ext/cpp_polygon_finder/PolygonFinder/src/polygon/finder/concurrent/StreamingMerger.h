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
 protected:
  std::ofstream* stream;
  int moved = 0;

  void stream_polygons(Tile* tile, bool flush = false);
  virtual void stream_raw_polygon(const Shape* shape);
  virtual void write_header() = 0;
  virtual void write_footer() = 0;
  virtual void write_outer_polygon_start() = 0;
  virtual void write_outer_polygon_end() = 0;
  virtual void write_inner_polygon_start() = 0;
  virtual void write_inner_polygon_end() = 0;
  void ensure_header();
  void ensure_footer();

 public:
  StreamingMerger(int number_of_threads,
                  std::vector<std::string>* options,
                  std::ofstream* stream_to);
  void add_tile(ProcessResult& result, bool flush = false);
  ProcessResult* process_info() override;
};
