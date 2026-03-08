/*
 * RawBitmap.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <memory>
#include "RawBitmap.h"

RawBitmap::RawBitmap() : Bitmap("", 0),
  width(0),
  height(0) {
}

int RawBitmap::w() {
  return this->width;
}

int RawBitmap::h() {
  return this->height;
}

char RawBitmap::value_at(int x, int y) {
  return(0);
}

const unsigned char* RawBitmap::get_row_ptr(int y) const {
  return image.get() + (static_cast<size_t>(y) * static_cast<size_t>(width) * 4);
}

int RawBitmap::get_bytes_per_pixel() const {
  return this->bpp;
}

// source image format RGBA => returning uint ABGR
unsigned int RawBitmap::rgb_value_at(int x, int y) {
  uint32_t index = (static_cast<uint32_t>(y) * width + x) * 4;
  return *reinterpret_cast<const uint32_t*>(&image[index]);
}

void RawBitmap::draw_pixel(int x, int y, unsigned char r, unsigned char g, unsigned char b, unsigned char a) {
  if (x >= width || y >= height) return;
  unsigned char* p = &image[(static_cast<size_t>(y) * width + x) * bpp];
  p[0] = r;
  if (bpp > 1) p[1] = g;
  if (bpp > 2) p[2] = b;
  if (bpp > 3) p[3] = a;
}

uint32_t RawBitmap::define(uint width, uint height, int bytes_per_pixel, bool clear)
{ this->width = width;
  this->height = height;
  this->bpp = bytes_per_pixel;
  uint32_t dimension = (static_cast<uint32_t>(width) * static_cast<uint32_t>(height)) * bytes_per_pixel;
  this->image = std::make_unique<unsigned char[]>(dimension);
  if (clear) {
    std::fill(image.get(), image.get() + dimension, 0);
  }
  return dimension;
}

