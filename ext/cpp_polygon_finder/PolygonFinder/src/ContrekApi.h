/*
 * ContrekApi.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once

#include <string>
#include <vector>
#include <memory>
#include <cstdint>

#include "Finder.h"
#include "FastPngBitmap.h"
#include "RGBNotMatcher.h"
#include "RGBMatcher.h"

namespace Contrek {

enum class MatchMode {
  NOT_COLOR,    // Tracks border of what is not target color
  EXACT_COLOR   // Tracks border of what exactly matchs target color
};

enum class Connectivity {
  ORTHOGONAL = 4,        // up, down, left, right 4 directions
  OMNIDIRECTIONAL = 8    // 8 directions
};

struct Config {
  int threads = 4;
  int tiles = 2;
  bool compress_unique = false;
  bool compress_linear = false;
  bool compress_visvalingam = false;
  bool treemap = false;
  int32_t target_color = -1;
  MatchMode mode = MatchMode::NOT_COLOR;
  Connectivity connectivity_mode = Connectivity::ORTHOGONAL;
};

inline std::unique_ptr<ProcessResult> trace(const std::string& image_path, const Config& cfg = Config()) {
  auto bitmap = std::make_unique<FastPngBitmap>(image_path);

  int32_t color_to_match = (cfg.target_color == -1)
                           ? bitmap->rgb_value_at(0, 0)
                           : cfg.target_color;

  std::unique_ptr<Matcher> matcher;
  if (cfg.mode == MatchMode::NOT_COLOR) {
    matcher = std::make_unique<RGBNotMatcher>(color_to_match);
  } else {
    matcher = std::make_unique<RGBMatcher>(color_to_match);
  }

  std::vector<std::string> internal_args = {"--versus=a"};
  struct Mapping { bool flag; std::string_view arg; };
  const Mapping mappings[] = {
    {cfg.compress_unique,      "--compress_uniq"},
    {cfg.compress_linear,      "--compress_linear"},
    {cfg.compress_visvalingam, "--compress_visvalingam"},
    {cfg.treemap,              "--treemap"}
  };

  for (auto& m : mappings) {
      if (m.flag) internal_args.emplace_back(m.arg);
  }
  internal_args.push_back("--number_of_tiles=" + std::to_string(cfg.tiles));
  if(cfg.connectivity_mode == Connectivity::OMNIDIRECTIONAL) {
    internal_args.push_back("--connectivity=" + std::to_string(8));
  }

  Finder finder(cfg.threads, bitmap.get(), matcher.get(), &internal_args);

  return std::unique_ptr<ProcessResult>(finder.process_info());
}

}  // namespace Contrek
