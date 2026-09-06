/*
 * RasterSource.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once

#include <cstddef>
#include <cstdint>

class RasterSource {
 public:
  virtual ~RasterSource() = default;
  virtual uint32_t width() const = 0;
  virtual uint32_t height() const = 0;
  virtual uint32_t get_bytes_per_pixel() const = 0;
  virtual bool read_next_row(unsigned char* destination, std::size_t row_size) = 0;
};
