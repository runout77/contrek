/*
 * RGBMatcher.cpp
 *
 *  Created on: 05 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
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
