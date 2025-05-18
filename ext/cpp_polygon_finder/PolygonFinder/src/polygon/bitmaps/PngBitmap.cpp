/*
 * PngBitmap.cpp
 *
 *  Created on: 03 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */
// http://www.piko3d.net/tutorials/libpng-tutorial-loading-png-files-from-streams/
#include "PngBitmap.h"
#include <stdlib.h>
#include <stdio.h>
#include <string>
#include <iostream>
#include <typeinfo>
#include "../matchers/RGBMatcher.h"
#include "../matchers/RGBNotMatcher.h"
#include "png++/png.hpp"

PngBitmap::PngBitmap(std::string filename) : Bitmap("", 0) {
  this->image = png::image< png::rgb_pixel >(filename);
  this->width = image.get_width();
  this->height = image.get_height();
}

bool PngBitmap::pixel_match(int x, int y, Matcher *matcher)
{ png::basic_rgb_pixel<unsigned char> pixel = image.get_pixel(x, y);
  unsigned int color = pixel.blue + (pixel.green << 8) + (pixel.red << 16);

  if (typeid(*matcher) == typeid(RGBMatcher)) return(((RGBMatcher*) matcher)->match(color));
  if (typeid(*matcher) == typeid(RGBNotMatcher)) return(((RGBNotMatcher*) matcher)->match(color));
  return(false);
}


PngBitmap::~PngBitmap() {
}

int PngBitmap::w() {
  return this->width;
}
int PngBitmap::h() {
  return this->height;
}
char PngBitmap::value_at(int x, int y) {
  png::basic_rgb_pixel<unsigned char> pixel = image.get_pixel(x, y);
  char color = pixel.blue | pixel.green | pixel.red;
  return(color);
}
