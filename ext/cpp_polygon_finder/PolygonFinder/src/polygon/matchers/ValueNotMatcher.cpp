/*
 * ValueNotMatcher.cpp
 *
 *  Created on: 27 nov 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include "ValueNotMatcher.h"
#include <iostream>

ValueNotMatcher::ValueNotMatcher(char value) : Matcher(value) {
}

ValueNotMatcher::~ValueNotMatcher() {
}

bool ValueNotMatcher::match(char value) {
  return(this->value != value);
}
