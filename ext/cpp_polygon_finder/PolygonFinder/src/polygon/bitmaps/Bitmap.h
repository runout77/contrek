/*
 * Bitmap.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
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
