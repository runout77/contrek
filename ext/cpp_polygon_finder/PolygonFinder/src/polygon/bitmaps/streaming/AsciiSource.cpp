/*
 * AsciiSource.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "AsciiSource.h"
#include <cstring>
#include <stdexcept>

AsciiSource::AsciiSource(Bitmap& bitmap)
  : bitmap_(bitmap),
    current_row_(0) {
}

uint32_t AsciiSource::width() const {
  return static_cast<uint32_t>(bitmap_.w());
}

uint32_t AsciiSource::height() const {
  return static_cast<uint32_t>(bitmap_.h());
}

uint32_t AsciiSource::get_bytes_per_pixel() const {
  return static_cast<uint32_t>(bitmap_.get_bytes_per_pixel());
}

bool AsciiSource::read_next_row(unsigned char* destination, std::size_t row_size)
{ if (current_row_ >= height()) {
    return false;
  }

  const unsigned char* row = bitmap_.get_row_ptr(current_row_);
  const std::size_t expected_row_size = static_cast<std::size_t>(width()) * static_cast<std::size_t>(get_bytes_per_pixel());

  if (expected_row_size != row_size) {
    throw std::runtime_error("Invalid row size");
  }
  std::memcpy(destination, row, row_size);
  ++current_row_;

  return true;
}
