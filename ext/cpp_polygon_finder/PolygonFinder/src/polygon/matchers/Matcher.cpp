/*
 * Matcher.cpp
 *
 *  Created on: 25 nov 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include "Matcher.h"
#include <iostream>
Matcher::Matcher(char value) {
  this->value = value;
}

Matcher::~Matcher() {
}

bool Matcher::match(char value) {
  return(this->value == value);
}
bool Matcher::unmatch(char value) {
  return(!match(value));
}
