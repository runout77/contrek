/*
 * RGBMatcher.cpp
 *
 *  Created on: 05 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include "RGBNotMatcher.h"
#include <iostream>
RGBNotMatcher::RGBNotMatcher(unsigned int rgb_value) : Matcher(0L) {
  this->rgb_value = rgb_value;
}

RGBNotMatcher::~RGBNotMatcher() {
}

bool RGBNotMatcher::match(unsigned int value) {
  return(this->rgb_value != value);
}
