/*
 * RGBMatcher.h
 *
 *  Created on: 05 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#ifndef POLYGON_MATCHERS_RGBMATCHER_H_
#define POLYGON_MATCHERS_RGBMATCHER_H_

#include "Matcher.h"

class RGBMatcher : public Matcher {
 public:
  RGBMatcher(unsigned int rgb_value);
  virtual ~RGBMatcher();
  bool match(unsigned int value);
 private:
  unsigned int rgb_value;
};

#endif /* POLYGON_MATCHERS_RGBMATCHER_H_ */
