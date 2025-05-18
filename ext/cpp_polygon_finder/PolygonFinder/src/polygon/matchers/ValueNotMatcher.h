/*
 * ValueNotMatcher.h
 *
 *  Created on: 27 nov 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#ifndef POLYGON_MATCHERS_VALUENOTMATCHER_H_
#define POLYGON_MATCHERS_VALUENOTMATCHER_H_

#include "Matcher.h"

class ValueNotMatcher : public Matcher {
 public:
  ValueNotMatcher(char value);
  virtual ~ValueNotMatcher();
  bool match(char value);
};

#endif /* POLYGON_MATCHERS_VALUENOTMATCHER_H_ */
