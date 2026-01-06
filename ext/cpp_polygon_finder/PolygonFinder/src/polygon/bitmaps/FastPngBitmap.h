/*
 * FastPngBitmap.h
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <vector>
#include <cstddef>
#include <string>
#include "Bitmap.h"

class RGBMatcher;

static const std::string base64_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

class FastPngBitmap : public Bitmap {
 public:
  explicit FastPngBitmap(std::string filename);
  bool pixel_match(int x, int y, Matcher *matcher);
  int h();
  int w();
  virtual int error();
  char value_at(int x, int y);
  unsigned int rgb_value_at(int x, int y);
  const unsigned char* get_row_ptr(int y) const;
  int get_bytes_per_pixel() const;

 protected:
  std::vector<unsigned char> buffer;
  std::vector<unsigned char> base64_decode(std::string &encoded_string);
  std::vector<unsigned char> image;
  unsigned int width, height;
  int png_error;
  int decodePNG(std::vector<unsigned char>& out_image, unsigned long& image_width, unsigned long& image_height, const unsigned char* in_png, size_t in_size, bool convert_to_rgba32 = true);

 private:
  void loadFile(std::vector<unsigned char>& buffer, const std::string& filename);
};
