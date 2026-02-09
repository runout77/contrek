/*
 * Matcher.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "Matcher.h"
#include <iostream>
Matcher::Matcher(unsigned int value) {
  this->value = value;
}

Matcher::~Matcher() {
}

bool Matcher::match(unsigned int value) {
  return(this->value == value);
}
bool Matcher::unmatch(unsigned int value) {
  return(!match(value));
}
