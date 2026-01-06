/*
 * Bitmap.h
 *
 *  Created on: 25 nov 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <string>

class Matcher;

class Bitmap {
 private:
  int module;
  std::string raw;
 public:
  Bitmap(std::string data, int mod);
  virtual ~Bitmap();
  virtual int h();
  virtual int w();
  virtual int error();
  virtual char value_at(int x, int y);
  void value_set(int x, int y, char value);
  void print();
  void clear(char value);
  virtual bool pixel_match(int x, int y, Matcher *matcher);
  virtual const unsigned char* get_row_ptr(int y) const;
  virtual int get_bytes_per_pixel() const;
};
