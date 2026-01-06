/*
 * RGBMatcher.h
 *
 *  Created on: 05 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include "Matcher.h"

class RGBNotMatcher : public Matcher {
 public:
  explicit RGBNotMatcher(unsigned int rgb_value);
  virtual ~RGBNotMatcher();
  bool match(unsigned int value) override;
 private:
  unsigned int rgb_value;
};
