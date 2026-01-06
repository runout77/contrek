/*
 * Matcher.h
 *
 *  Created on: 25 nov 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once

class Matcher {
 protected:
  unsigned int value;

 public:
  explicit Matcher(unsigned int value);
  virtual bool match(unsigned int value);
  virtual bool unmatch(unsigned int value);
  virtual ~Matcher();
};
