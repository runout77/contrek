/*
 * PngSource.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "PngSource.h"

#include <stdexcept>
#include <string>

PngSource::PngSource(const std::string& filepath)
  : fp_(nullptr),
    ctx_(nullptr),
    width_(0),
    height_(0),
    current_row_(0) {
  fp_ = std::fopen(filepath.c_str(),"rb");
  if (!fp_) {
    throw std::runtime_error("Unable to open PNG file");
  }

  ctx_ = spng_ctx_new(0);
  if (!ctx_) {
    std::fclose(fp_);
    fp_ = nullptr;
    throw std::runtime_error("Unable to create spng context");
  }

  int ret = spng_set_png_file(ctx_,fp_);
  if (ret != 0) {
    spng_ctx_free(ctx_);
    ctx_ = nullptr;
    std::fclose(fp_);
    fp_ = nullptr;
    throw std::runtime_error(std::string("spng_set_png_file failed: ") + spng_strerror(ret));
  }

  spng_ihdr ihdr{};
  ret = spng_get_ihdr(ctx_, &ihdr);

  if (ret != 0) {
    spng_ctx_free(ctx_);
    ctx_ = nullptr;
    std::fclose(fp_);
    fp_ = nullptr;
    throw std::runtime_error(std::string("spng_get_ihdr failed: ") + spng_strerror(ret));
  }

  width_ = static_cast<uint32_t>(ihdr.width);
  height_ = static_cast<uint32_t>(ihdr.height);
  ret = spng_decode_image(
    ctx_,
    nullptr,
    0,
    SPNG_FMT_RGBA8,
    SPNG_DECODE_PROGRESSIVE
  );

  if (ret != 0) {
    spng_ctx_free(ctx_);
    ctx_ = nullptr;
    std::fclose(fp_);
    fp_ = nullptr;
    throw std::runtime_error(std::string("spng_decode_image failed: ") + spng_strerror(ret));
  }
}

PngSource::~PngSource()
{ if (ctx_) {
    spng_ctx_free(ctx_);
  }
  if (fp_) {
    std::fclose(fp_);
  }
}

uint32_t PngSource::width() const {
  return width_;
}

uint32_t PngSource::height() const {
  return height_;
}

uint32_t PngSource::get_bytes_per_pixel() const {
  return 4;
}

bool PngSource::read_next_row(unsigned char* destination, std::size_t row_size) {
  if (current_row_ >= height_) {
    return false;
  }
  const std::size_t expected_row_size = static_cast<std::size_t>(width_) * 4;
  if (row_size != expected_row_size) {
    throw std::runtime_error("Invalid row size");
  }
  const int ret = spng_decode_row(ctx_,destination,row_size);

  if (ret != 0 && ret != SPNG_EOI) {
    throw std::runtime_error(std::string("spng_decode_row failed: ") + spng_strerror(ret));
  }
  ++current_row_;
  return true;
}