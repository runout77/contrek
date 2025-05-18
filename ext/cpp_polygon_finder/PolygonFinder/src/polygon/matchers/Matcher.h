/*
 * Matcher.h
 *
 *  Created on: 25 nov 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#ifndef POLYGON_MATCHERS_MATCHER_H_
#define POLYGON_MATCHERS_MATCHER_H_

class Matcher {
 protected:
  char value;

 public:
  Matcher(char value);
  virtual bool match(char value);
  virtual bool unmatch(char value);
  virtual ~Matcher();
};

#endif /* POLYGON_MATCHERS_MATCHER_H_ */
