/*
 * ValueNotMatcher.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "ValueNotMatcher.h"
#include <iostream>

ValueNotMatcher::ValueNotMatcher(unsigned int value) : Matcher(value) {
}

ValueNotMatcher::~ValueNotMatcher() {
}

bool ValueNotMatcher::match(unsigned int value) {
  return(this->value != value);
}
