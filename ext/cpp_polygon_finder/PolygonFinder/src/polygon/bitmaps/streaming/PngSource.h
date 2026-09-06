/*
 * PngSource.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once

#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <string>

extern "C" {
#include "../spng.h"
}

#include "RasterSource.h"

class PngSource : public RasterSource {
 public:
  explicit PngSource(const std::string& filepath);
  ~PngSource() override;

  uint32_t width() const override;
  uint32_t height() const override;
  uint32_t get_bytes_per_pixel() const override;
  bool read_next_row(unsigned char* destination, std::size_t row_size) override;

 private:
  FILE* fp_;
  spng_ctx* ctx_;

  uint32_t width_;
  uint32_t height_;
  uint32_t current_row_;
};
