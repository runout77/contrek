/*
 * HorizontalMerger.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <string>
#include <vector>
#include "Merger.h"

class HorizontalMerger : public Merger {
 public:
  HorizontalMerger(int number_of_threads, std::vector<std::string> *options);
  void add_tile(ProcessResult& result) override;
};
