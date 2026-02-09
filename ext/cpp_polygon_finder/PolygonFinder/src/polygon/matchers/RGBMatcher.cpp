/*
 * RGBMatcher.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "RGBMatcher.h"
#include <iostream>
RGBMatcher::RGBMatcher(unsigned int rgb_value) : Matcher(0L) {
  this->rgb_value = rgb_value;
}

RGBMatcher::~RGBMatcher() {
}

bool RGBMatcher::match(unsigned int value) {
  return(this->rgb_value == value);
}
