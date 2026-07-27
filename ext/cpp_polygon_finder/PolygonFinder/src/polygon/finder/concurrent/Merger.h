/*
 * Merger.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <string>
#include <vector>
#include "Finder.h"
#include "../Options.h"

class Merger : public Finder {
 public:
  Merger(int number_of_threads, const Options& options);
  virtual void add_tile(ProcessResult& result);
  ProcessResult* process_info() override;
  bool safe();

 protected:
  void translate(ProcessResult& result, int offset);
  int current_x = 0;
};
