/*
 * FinderUtils.h
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <string>
#include <vector>

class FinderUtils {
 public:
  static void sanitize_options(pf_Options& options, std::vector<std::string> *incoming_options);
};
