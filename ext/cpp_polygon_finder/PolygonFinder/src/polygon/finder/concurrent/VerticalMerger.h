/*
 * VerticalMerger.h
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

class VerticalMerger : public Merger {
 public:
  VerticalMerger(int number_of_threads, std::vector<std::string> *options);
  void add_tile(ProcessResult& result) override;
  ProcessResult* process_info() override;

 private:
  void transpose(ProcessResult& result);
  void adjust(ProcessResult& result);
};
