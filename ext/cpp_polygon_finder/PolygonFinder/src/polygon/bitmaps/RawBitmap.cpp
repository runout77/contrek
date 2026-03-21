/*
 * RawBitmap.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <memory>
#include <cstdio>
#include <iostream>
#include <cstring>
#include <cerrno>
#include <string>
#include "spng.h"
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
  if (x < 0 || x >= width || y < 0 || y >= height) return;
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

void RawBitmap::fill(unsigned char r, unsigned char g, unsigned char b, unsigned char a) {
  if (!image) return;
  size_t size = static_cast<size_t>(width) * height * bpp;

  if (r == g && g == b && b == a) {
    std::memset(image.get(), r, size);
  } else {
    for (size_t i = 0; i < size; i += bpp) {
      image[i] = r;
      if (bpp > 1) image[i+1] = g;
      if (bpp > 2) image[i+2] = b;
      if (bpp > 3) image[i+3] = a;
    }
  }
}

void RawBitmap::draw_line(int x0, int y0, int x1, int y1, unsigned char r, unsigned char g, unsigned char b, unsigned char a) {
  int dx = abs(x1 - x0), sx = x0 < x1 ? 1 : -1;
  int dy = -abs(y1 - y0), sy = y0 < y1 ? 1 : -1;
  int err = dx + dy, e2;
  while (true) {
    draw_pixel(x0, y0, r, g, b, a);
    if (x0 == x1 && y0 == y1) break;
    e2 = 2 * err;
    if (e2 >= dy) {
      err += dy; x0 += sx;
    }
    if (e2 <= dx) {
      err += dx; y0 += sy;
    }
  }
}

void RawBitmap::draw_filled_rectangle(int x, int y, int w, int h, unsigned char r, unsigned char g, unsigned char b, unsigned char a) {
  if (w <= 0 || h <= 0) return;

  for (int i = 0; i < h; ++i) {
    int current_y = y + i;
    this->draw_line(x, current_y, x + w - 1, current_y, r, g, b, a);
  }
}

bool RawBitmap::save_to_png(const std::string& filename) {
  if (this->width == 0 || this->height == 0 || !this->image) {
    std::cerr << "Error: Bitmap empty or uninitialized" << std::endl;
    return false;
  }
  FILE *fp = fopen(filename.c_str(), "wb");
  if (!fp) {
    std::cerr << "Unable open file" << filename << ": "
              << std::strerror(errno) << std::endl;
    return false;
  }
  spng_ctx *ctx = spng_ctx_new(SPNG_CTX_ENCODER);
  if (!ctx) {
    fclose(fp);
    return false;
  }
  spng_set_png_file(ctx, fp);
  struct spng_ihdr ihdr;
  std::memset(&ihdr, 0, sizeof(struct spng_ihdr));

  ihdr.width = this->width;
  ihdr.height = this->height;
  ihdr.bit_depth = 8;

  // color type by bpp
  // 6 = RGBA (Truecolor with Alpha)
  // 2 = RGB  (Truecolor)
  ihdr.color_type = (this->bpp == 4) ? 6 : 2;

  int ret = spng_set_ihdr(ctx, &ihdr);
  if (ret) {
    std::cerr << "Error spng_set_ihdr: " << spng_strerror(ret) << std::endl;
    spng_ctx_free(ctx);
    fclose(fp);
    return false;
  }

  // encoding
  size_t image_size = static_cast<size_t>(this->width) * this->height * this->bpp;
  ret = spng_encode_image(ctx, this->image.get(), image_size, SPNG_FMT_PNG, SPNG_ENCODE_FINALIZE);
  if (ret) {
    std::cerr << "Encoding error: " << spng_strerror(ret) << " (code: " << ret << ")" << std::endl;
    std::cerr << "Data W: " << width << " H: " << height << " BPP: " << bpp << " Size: " << image_size << std::endl;
  }

  spng_ctx_free(ctx);
  fflush(fp);
  fclose(fp);

  return (ret == 0);
}
