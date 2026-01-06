/*
 * Matcher.cpp
 *
 *  Created on: 25 nov 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
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
