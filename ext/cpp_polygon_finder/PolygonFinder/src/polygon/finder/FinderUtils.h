/*
 * FinderUtils.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <string>
#include <vector>

class FinderUtils {
 public:
  static void sanitize_options(pf_Options& options, std::vector<std::string> *incoming_options);
};
