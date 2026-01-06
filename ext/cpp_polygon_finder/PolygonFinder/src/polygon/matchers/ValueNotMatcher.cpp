/*
 * ValueNotMatcher.cpp
 *
 *  Created on: 27 nov 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
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
