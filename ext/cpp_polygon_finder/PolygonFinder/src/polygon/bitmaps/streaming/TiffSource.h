/*
 * TiffSource.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once

#include "RasterSource.h"
#include "GeoLocalization.h"

#include <cstddef>
#include <cstdint>
#include <string>
#include <vector>

struct tiff;
typedef struct tiff TIFF;

class TiffSource : public RasterSource {
 public:
  explicit TiffSource(const std::string& filepath, bool suppress_warnings = false);
  ~TiffSource() override;
  uint32_t width() const override;
  uint32_t height() const override;
  uint32_t get_bytes_per_pixel() const override;
  bool read_next_row(unsigned char* destination, std::size_t row_size) override;
  const GeoLocalization& geo_localization() const;

 private:
  void read_image_info();
  void read_geo_localization();
  void read_pixel_scale_and_tiepoint();
  void read_model_transformation(double* matrix, uint16_t count);
  void read_crs();
  void convert_row(unsigned char* destination);
  TIFF* tiff_;
  uint32_t width_;
  uint32_t height_;
  uint16_t bits_per_sample_;
  uint16_t samples_per_pixel_;
  uint16_t photometric_;
  uint16_t planar_config_;
  uint16_t sample_format_;
  uint32_t current_row_;
  std::vector<unsigned char> source_row_;
  GeoLocalization geo_localization_;
};
