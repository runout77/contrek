/*
 * FastPngBitmap.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <vector>
#include <cstddef>
#include <string>
#include "RawBitmap.h"

class RGBMatcher;

static const std::string base64_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

class FastPngBitmap : public RawBitmap {
 public:
  explicit FastPngBitmap(std::string filename);
  virtual int error();

 protected:
  std::vector<unsigned char> buffer;
  std::vector<unsigned char> base64_decode(std::string &encoded_string);
  int png_error;
  int decodePNG(std::vector<unsigned char>& out_image, unsigned long& image_width, unsigned long& image_height, const unsigned char* in_png, size_t in_size, bool convert_to_rgba32 = true);

 private:
  void loadFile(std::vector<unsigned char>& buffer, const std::string& filename);
};
