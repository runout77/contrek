/*
 * FastPngBitmap.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <sys/mman.h>
#include <iostream>
#include <vector>
#include <fstream>
#include <cstddef>
#include <typeinfo>
#include <string>
#include <cstring>
#include "../matchers/RGBMatcher.h"
#include "../matchers/RGBNotMatcher.h"
#include "FastPngBitmap.h"
#include "spng.h"

FastPngBitmap::FastPngBitmap(std::string filename) : Bitmap("", 0) {
  if (filename.length() > 0)
  { std::ifstream file(filename, std::ios::binary | std::ios::ate);
    if (file.is_open())
    { std::streamsize size = file.tellg();
      file.seekg(0, std::ios::beg);
      std::vector<unsigned char> file_buffer(size);
      if (!file.read(reinterpret_cast<char*>(file_buffer.data()), size))
      { this->png_error = -1;
      } else {
        spng_ctx *ctx = spng_ctx_new(0);
        spng_set_png_buffer(ctx, file_buffer.data(), file_buffer.size());
        struct spng_ihdr ihdr;
        spng_get_ihdr(ctx, &ihdr);
        this->width = ihdr.width;
        this->height = ihdr.height;
        size_t out_size;
        spng_decoded_image_size(ctx, SPNG_FMT_RGBA8, &out_size);
        this->image.resize(out_size);
        madvise(this->image.data(), out_size, MADV_HUGEPAGE);
        int error = spng_decode_image(ctx, image.data(), out_size, SPNG_FMT_RGBA8, SPNG_DECODE_TRNS);
        spng_ctx_free(ctx);
        this->png_error = error;
      }
    }
  }
}

bool FastPngBitmap::pixel_match(int x, int y, Matcher *matcher)
{ int32_t index = ((y * width) + x) * 4;
  unsigned int color;
  unsigned char *red = &image[index];
  std::memcpy(&color, red, 3);
  if (typeid(*matcher) == typeid(RGBMatcher))  return((reinterpret_cast<RGBMatcher*>(matcher))->match(color));
  if (typeid(*matcher) == typeid(RGBNotMatcher)) return((reinterpret_cast<RGBNotMatcher*>(matcher))->match(color));
  return(false);
}

int FastPngBitmap::w() {
  return this->width;
}

int FastPngBitmap::h() {
  return this->height;
}

int FastPngBitmap::error() {
  return this->png_error;
}
char FastPngBitmap::value_at(int x, int y) {
  return(0);
}

// source image format RGBA => returning uint ABGR
unsigned int FastPngBitmap::rgb_value_at(int x, int y) {
  uint32_t index = (uint32_t(y) * width + x) * 4;
  return *reinterpret_cast<const uint32_t*>(&image[index]);
}

const unsigned char* FastPngBitmap::get_row_ptr(int y) const {
  return image.data() + (static_cast<size_t>(y) * static_cast<size_t>(width) * 4);
}

int FastPngBitmap::get_bytes_per_pixel() const {
  return 4;  // RGBA
}

void FastPngBitmap::loadFile(std::vector<unsigned char>& buffer, const std::string& filename)  // designed for loading files from hard disk in an std::vector
{ std::ifstream file(filename.c_str(), std::ios::in|std::ios::binary|std::ios::ate);
  // get filesize
  std::streamsize size = 0;
  if (file.seekg(0, std::ios::end).good()) size = file.tellg();
  if (file.seekg(0, std::ios::beg).good()) size -= file.tellg();
  // read contents of the file into the vector
  if (size > 0)
  { buffer.resize(static_cast<size_t>(size));
    file.read(reinterpret_cast<char*>(&buffer[0]), size);
  }
  else buffer.clear();
}

static inline bool is_base64(unsigned char c) {
  return (isalnum(c) || (c == '+') || (c == '/'));
}

std::vector<unsigned char> FastPngBitmap::base64_decode(std::string &encoded_string) {
  int in_len = encoded_string.size();
  int i = 0;
  int j = 0;
  int in_ = 0;
  unsigned char char_array_4[4], char_array_3[3];
  std::vector<unsigned char> ret;

  while (in_len-- && (encoded_string[in_] != '=') && is_base64(encoded_string[in_])) {
    char_array_4[i++] = encoded_string[in_]; in_++;
    if (i ==4) {
      for (i = 0; i <4; i++)
        char_array_4[i] = base64_chars.find(char_array_4[i]);

      char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
      char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
      char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

      for (i = 0; (i < 3); i++)
          ret.push_back(char_array_3[i]);
      i = 0;
    }
  }

  if (i) {
    for (j = i; j <4; j++)
      char_array_4[j] = 0;

    for (j = 0; j <4; j++)
      char_array_4[j] = base64_chars.find(char_array_4[j]);

    char_array_3[0] = (char_array_4[0] << 2) + ((char_array_4[1] & 0x30) >> 4);
    char_array_3[1] = ((char_array_4[1] & 0xf) << 4) + ((char_array_4[2] & 0x3c) >> 2);
    char_array_3[2] = ((char_array_4[2] & 0x3) << 6) + char_array_4[3];

    for (j = 0; (j < i - 1); j++) ret.push_back(char_array_3[j]);
  }

  return ret;
}
