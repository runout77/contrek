/*
 * PngBitmap.h
 *
 *  Created on: 03 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#ifndef POLYGON_BITMAPS_PNGBITMAP_H_
#define POLYGON_BITMAPS_PNGBITMAP_H_

#include "Bitmap.h"
#include <string>
#include "png++/png.hpp"

class RGBMatcher;

class PngBitmap : public Bitmap {
 public:
  PngBitmap(std::string filename);
  virtual ~PngBitmap();
  bool pixel_match(int x, int y, Matcher *matcher);
  int h();
  int w();
  char value_at(int x, int y);
 private:
  unsigned int width;
  unsigned int height;
  png::image< png::rgb_pixel> image;
};

#endif /* POLYGON_BITMAPS_PNGBITMAP_H_ */
