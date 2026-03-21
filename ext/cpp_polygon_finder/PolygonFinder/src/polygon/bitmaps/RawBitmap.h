/*
 * RawBitmap.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <vector>
#include <memory>
#include <cstddef>
#include <string>
#include "Bitmap.h"

class RGBMatcher;

class RawBitmap : public Bitmap {
 public:
  explicit RawBitmap();
  int h();
  int w();
  char value_at(int x, int y);
  unsigned int rgb_value_at(int x, int y);
  const unsigned char* get_row_ptr(int y) const;
  int get_bytes_per_pixel() const;
  uint32_t define(uint width, uint height, int bytes_per_pixel, bool clear = false);
  void draw_pixel(int x, int y, unsigned char r, unsigned char g, unsigned char b, unsigned char a = 255);
  bool save_to_png(const std::string& filename);
  void fill(unsigned char r, unsigned char g, unsigned char b, unsigned char a = 255);
  void draw_line(int x0, int y0, int x1, int y1, unsigned char r, unsigned char g, unsigned char b, unsigned char a = 255);
  void draw_filled_rectangle(int x, int y, int w, int h, unsigned char r, unsigned char g, unsigned char b, unsigned char a = 255);

 protected:
  std::unique_ptr<unsigned char[]> image;
  unsigned int width, height;

 private:
  int bpp;
};
