/*
 * RasterStreamer.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <stdexcept>
#include <utility>
#include <vector>

#include "RasterSource.h"
#include "../RawBitmap.h"

class RasterStreamer {
 public:
  static constexpr uint32_t OVERLAP = 1;

  RasterStreamer(RasterSource& source, uint32_t stripe_height)
    : source_(source),
      stripe_height_(stripe_height) {
    if (stripe_height_ <= OVERLAP) {
      throw std::invalid_argument("stripe_height must be greater than 1");
    }
  }
  uint32_t stripe_height() const { return stripe_height_; }

  template <typename Callback>
  void each(Bitmap& buffer, Callback&& callback)
  { const uint32_t width = source_.width();
    const uint32_t height = source_.height();
    const uint32_t bytes_per_pixel = source_.get_bytes_per_pixel();
    const std::size_t row_size = static_cast<std::size_t>(width) * static_cast<std::size_t>(bytes_per_pixel);
    uint32_t source_row = 0;
    uint32_t previous_buffer_rows = 0;
    bool first_stripe = true;

    while (source_row < height) {
      std::vector<unsigned char> overlap_row;
      if (!first_stripe) {
        overlap_row.resize(row_size);
        const unsigned char* previous_last_row = buffer.get_row_ptr(previous_buffer_rows - 1);
        std::memcpy(overlap_row.data(), previous_last_row, row_size);
      }

      const uint32_t overlap_rows = first_stripe ? 0 : OVERLAP;
      const uint32_t available_rows = stripe_height_ - overlap_rows;
      const uint32_t remaining_rows = height - source_row;
      const uint32_t rows_to_read = std::min(available_rows, remaining_rows);
      const uint32_t buffer_rows = overlap_rows + rows_to_read;

      if (!first_stripe) {
        unsigned char* first_row = const_cast<unsigned char*>(buffer.get_row_ptr(0));
        std::memcpy(first_row, overlap_row.data(), row_size);
      }
      uint32_t rows_read = 0;
      for (uint32_t i = 0; i < rows_to_read; ++i) {
        const uint32_t buffer_y = overlap_rows + i;
        unsigned char* destination = const_cast<unsigned char*>(buffer.get_row_ptr(buffer_y));
        if (!source_.read_next_row(destination, row_size)) {
          break;
        }
        ++source_row;
        ++rows_read;
      }
      if (rows_read == 0) {
        break;
      }
      const uint32_t actual_buffer_rows = overlap_rows + rows_read;
      if (actual_buffer_rows != buffer_rows) {
        throw std::runtime_error("Raster source ended before expected image height!");
      }
      const std::size_t buffer_size = static_cast<std::size_t>(buffer_rows) * row_size;

      std::forward<Callback>(callback)(buffer, buffer_rows, buffer_size, rows_read);
      previous_buffer_rows = buffer_rows;
      first_stripe = false;
    }
  }

 private:
  RasterSource& source_;
  uint32_t stripe_height_;
};
