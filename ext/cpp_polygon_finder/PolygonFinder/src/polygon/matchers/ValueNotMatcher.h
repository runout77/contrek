/*
 * ValueNotMatcher.h
 *
 *  Created on: 27 nov 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include "Matcher.h"

class ValueNotMatcher : public Matcher {
 public:
  explicit ValueNotMatcher(unsigned int value);
  virtual ~ValueNotMatcher();
  bool match(unsigned int value);
};
