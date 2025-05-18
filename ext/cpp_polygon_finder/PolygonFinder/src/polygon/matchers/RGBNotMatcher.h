/*
 * RGBMatcher.h
 *
 *  Created on: 05 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#ifndef POLYGON_MATCHERS_RGBNOTMATCHER_H_
#define POLYGON_MATCHERS_RGBNOTMATCHER_H_

#include "Matcher.h"

class RGBNotMatcher : public Matcher {
 public:
  RGBNotMatcher(int rgb_value);
  virtual ~RGBNotMatcher();
  bool match(int value);
 private:
  int rgb_value;
};

#endif /* POLYGON_MATCHERS_RGBMATCHER_H_ */
