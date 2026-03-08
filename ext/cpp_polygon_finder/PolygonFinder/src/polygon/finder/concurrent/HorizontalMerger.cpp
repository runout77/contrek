/*
 * HorizontalMerger.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <iostream>
#include <string>
#include <vector>
#include "HorizontalMerger.h"

HorizontalMerger::HorizontalMerger(int number_of_threads, std::vector<std::string> *options)
: Merger(number_of_threads, options) {
}

void HorizontalMerger::add_tile(ProcessResult& result)
{ translate(result, this->current_x);
  Merger::add_tile(result);
}
