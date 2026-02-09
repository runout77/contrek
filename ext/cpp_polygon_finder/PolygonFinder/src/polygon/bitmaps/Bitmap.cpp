/*
 * Bitmap.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "Bitmap.h"
#include <string.h>
#include <iostream>
#include <string>
#include "../matchers/Matcher.h"

Bitmap::Bitmap(std::string data, int mod) {
  module = mod;
  raw = data;
}

Bitmap::~Bitmap() {
}

int Bitmap::w() {
  return module;
}
int Bitmap::h() {
  return raw.length() / module;
}
int Bitmap::error() {
  return 0;
}
char Bitmap::value_at(int x, int y) {
  return raw.at(y * module + x);
}
void Bitmap::value_set(int x, int y, char value) {
    if (y >= h() || x >= w()) return;
    if (value_at(x, y) != '0') value = 'X';
    raw[y*module + x] = value;
}
void Bitmap::print() {
  std::cout << "----------------------------"<< std::endl;
  for (int x = 0; x < h(); x++)
  { std::cout << raw.substr(module * x, module) << std::endl;
  }
  std::cout << "----------------------------"<< std::endl;
}
bool Bitmap::pixel_match(int x, int y, Matcher *matcher)
{ return(matcher->match(value_at(x, y)));
}
void Bitmap::clear(char value = '0')
{ for (unsigned int i = 0; i < raw.length(); i++) raw[i] = value;
}

const unsigned char* Bitmap::get_row_ptr(int y) const {
  return reinterpret_cast<const unsigned char*>(raw.data()) + (y * module);
}

int Bitmap::get_bytes_per_pixel() const {
  return 1;
}
