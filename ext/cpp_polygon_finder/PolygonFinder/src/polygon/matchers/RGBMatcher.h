/*
 * RGBMatcher.h
 *
 *  Created on: 05 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include "Matcher.h"

class RGBMatcher : public Matcher {
 public:
  explicit RGBMatcher(unsigned int rgb_value);
  virtual ~RGBMatcher();
  bool match(unsigned int value) override;
 private:
  unsigned int rgb_value;
};
