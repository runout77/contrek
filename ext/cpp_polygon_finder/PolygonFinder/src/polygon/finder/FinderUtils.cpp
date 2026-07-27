/*
 * FinderUtils.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <iostream>
#include <string>
#include <algorithm>
#include "PolygonFinder.h"
#include "FinderUtils.h"

void FinderUtils::sanitize_options(pf_Options& options, const Options& incoming_options) {
  const Identifier versus = incoming_options.get<Identifier>("versus", options.versus == Node::A ? "a" : "o");
  options.versus = versus == "a" ? Node::A : Node::O;
  options.number_of_tiles = std::max(1, static_cast<int>(incoming_options.get<std::int64_t>(
    "number_of_tiles",
    options.number_of_tiles)));
  options.connectivity_offset = incoming_options.get<std::int64_t>(
    "connectivity",
    options.connectivity_offset == 1 ? 8 : 4) == 8;
  options.treemap = incoming_options.get<bool>("treemap", options.treemap);
  options.named_sequences = incoming_options.get<bool>(
    "named_sequences",
    options.named_sequences);
  options.bounds = incoming_options.get<bool>("bounds", options.bounds);
  options.unsafe_mode = incoming_options.get<bool>("unsafe_mode", options.unsafe_mode);

  if (const Options* compress = incoming_options.get_options("compress")) {
    options.compress_uniq = compress->get<bool>("uniq", options.compress_uniq);
    options.compress_linear = compress->get<bool>("linear", options.compress_linear);
    options.compress_raster = compress->get<bool>("raster", options.compress_raster);
    options.compress_douglas_peucker = compress->get<bool>("douglas_peucker", options.compress_douglas_peucker);
    options.compress_visvalingam = compress->get<bool>("visvalingam", options.compress_visvalingam);
    if (compress->contains("visvalingam_tolerance")) {
      options.compress_visvalingam = true;
      options.compress_visvalingam_tolerance = static_cast<float>(compress->get<double>(
        "visvalingam_tolerance",
        options.compress_visvalingam_tolerance));
    }
  }

/*std::cout << "-----------" << std::endl;
  std::cout << "versus " << options.versus << std::endl;
  std::cout << "bounds " << options.bounds << std::endl;
  std::cout << "number_of_tiles " << options.number_of_tiles << std::endl;
  std::cout << "uniq " << options.compress_uniq << std::endl;
  std::cout << "linear " << options.compress_linear << std::endl;
  std::cout << "treemap " << options.treemap << std::endl;
  std::cout << "visvalingam " << options.compress_visvalingam << std::endl;
  std::cout << "visvalingam tolerance " << options.compress_visvalingam_tolerance << std::endl;
  std::cout << "-----------" << std::endl; */
}
