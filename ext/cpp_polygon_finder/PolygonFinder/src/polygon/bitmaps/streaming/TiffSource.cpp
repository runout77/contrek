/*
 * TiffSource.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "TiffSource.h"

#include <geotiff/geotiff.h>
#include <geotiff/geotiffio.h>
#include <geotiff/geokeys.h>
#include <geotiff/xtiffio.h>
#include <tiffio.h>
#include <algorithm>
#include <cstring>
#include <limits>
#include <stdexcept>
#include <string>

static const uint32_t TIFFTAG_MODELPIXELSCALE = 33550;
static const uint32_t TIFFTAG_MODELTIEPOINT = 33922;
static const uint32_t TIFFTAG_MODELTRANSFORMATION = 34264;

TiffSource::TiffSource(const std::string& filepath, bool suppress_warnings)
  : tiff_(nullptr),
    width_(0),
    height_(0),
    bits_per_sample_(0),
    samples_per_pixel_(0),
    photometric_(0),
    planar_config_(0),
    sample_format_(0),
    current_row_(0),
    tiled_(false),
    tile_width_(0),
    tile_height_(0),
    cached_tile_start_(0),
    tile_cache_valid_(false) {
  if (suppress_warnings) {
    TIFFSetWarningHandler(nullptr);
  }
  tiff_ = XTIFFOpen(filepath.c_str(), "r");

  if (!tiff_) {
    throw std::runtime_error("Unable to open TIFF: " + filepath);
  }

  try {
    read_image_info();
    read_geo_localization();

    const tmsize_t scanline_size = TIFFScanlineSize(tiff_);
    if (scanline_size <= 0) throw std::runtime_error("Invalid TIFF scanline size");
    source_row_.resize(static_cast<std::size_t>(scanline_size));

    if (tiled_) {
      TIFFGetField(tiff_, TIFFTAG_TILEWIDTH, &tile_width_);
      TIFFGetField(tiff_, TIFFTAG_TILELENGTH, &tile_height_);
      if (!tile_width_ || !tile_height_) throw std::runtime_error("Invalid TIFF tile dimensions");
      const std::size_t row_bytes = static_cast<std::size_t>(width_) * samples_per_pixel_ * (bits_per_sample_ / 8);
      if (row_bytes > source_row_.size())
        throw std::runtime_error("TIFF scanline buffer is smaller than the decoded pixel row");
      if (row_bytes > std::numeric_limits<std::size_t>::max() / tile_height_)
        throw std::runtime_error("TIFF tile cache too large");
      tile_band_.resize(row_bytes * tile_height_);
    }
  }
  catch (...) {
    XTIFFClose(tiff_);
    tiff_ = nullptr;
    throw;
  }
}

TiffSource::~TiffSource() {
  if (tiff_) {
    XTIFFClose(tiff_);
    tiff_ = nullptr;
  }
}

uint32_t TiffSource::width() const {
  return width_;
}

uint32_t TiffSource::height() const {
  return height_;
}

uint32_t TiffSource::get_bytes_per_pixel() const {
  return 4;
}

const GeoLocalization& TiffSource::geo_localization() const {
  return geo_localization_;
}

void TiffSource::read_image_info() {
  if (!TIFFGetField(tiff_, TIFFTAG_IMAGEWIDTH, &width_)) throw std::runtime_error("Unable to read TIFF width");
  if (!TIFFGetField(tiff_, TIFFTAG_IMAGELENGTH, &height_)) throw std::runtime_error("Unable to read TIFF height");

  TIFFGetFieldDefaulted(tiff_, TIFFTAG_BITSPERSAMPLE, &bits_per_sample_);
  TIFFGetFieldDefaulted(tiff_, TIFFTAG_SAMPLESPERPIXEL, &samples_per_pixel_);

  if (!TIFFGetField(tiff_, TIFFTAG_PHOTOMETRIC, &photometric_)) throw std::runtime_error("Unable to read TIFF photometric");

  TIFFGetFieldDefaulted(tiff_, TIFFTAG_PLANARCONFIG, &planar_config_);
  TIFFGetFieldDefaulted(tiff_, TIFFTAG_SAMPLEFORMAT, &sample_format_);

  tiled_ = TIFFIsTiled(tiff_) != 0;
  if (planar_config_ != PLANARCONFIG_CONTIG) throw std::runtime_error("Unsupported TIFF planar configuration");
  if (bits_per_sample_ != 8 && bits_per_sample_ != 16) throw std::runtime_error("Unsupported TIFF bits per sample");
  if (samples_per_pixel_ != 1 && samples_per_pixel_ != 3 && samples_per_pixel_ != 4) throw std::runtime_error("Unsupported TIFF samples per pixel");
  if (sample_format_ != SAMPLEFORMAT_UINT) throw std::runtime_error("Unsupported TIFF sample format");

  if (photometric_ != PHOTOMETRIC_MINISWHITE &&
      photometric_ != PHOTOMETRIC_MINISBLACK &&
      photometric_ != PHOTOMETRIC_RGB &&
      photometric_ != PHOTOMETRIC_PALETTE) {
    throw std::runtime_error("Unsupported TIFF photometric");
  }
  if (photometric_ == PHOTOMETRIC_PALETTE && (samples_per_pixel_ != 1 || bits_per_sample_ != 8)) {
    throw std::runtime_error("Only 8-bit single-band palette TIFF is supported");
  }
}

void TiffSource::read_geo_localization() {
  double* matrix = nullptr;
  uint16_t matrix_count = 0;

  if (TIFFGetField(tiff_, TIFFTAG_MODELTRANSFORMATION, &matrix_count, &matrix) && matrix && matrix_count >= 16) {
    read_model_transformation(matrix, matrix_count);
  } else {
    read_pixel_scale_and_tiepoint();
  }

  if (geo_localization_.valid) read_crs();
}

void TiffSource::read_model_transformation(double* matrix, uint16_t count) {
  if (!matrix || count < 16) return;

  GeoTransform& transform = geo_localization_.transform;

  transform.x_pixel_size = matrix[0];
  transform.x_row_offset = matrix[1];
  transform.x_origin = matrix[3];

  transform.y_column_offset = matrix[4];
  transform.y_pixel_size = matrix[5];
  transform.y_origin = matrix[7];

  geo_localization_.valid = true;
}

void TiffSource::read_pixel_scale_and_tiepoint() {
  double* scale = nullptr;
  double* tiepoint = nullptr;

  uint16_t scale_count = 0;
  uint16_t tiepoint_count = 0;

  if (!TIFFGetField(tiff_, TIFFTAG_MODELPIXELSCALE, &scale_count, &scale)) return;
  if (!TIFFGetField(tiff_, TIFFTAG_MODELTIEPOINT, &tiepoint_count, &tiepoint)) return;
  if (!scale || !tiepoint || scale_count < 2 || tiepoint_count < 6) return;

  const double pixel_x = tiepoint[0];
  const double pixel_y = tiepoint[1];

  const double model_x = tiepoint[3];
  const double model_y = tiepoint[4];

  const double x_pixel_size = scale[0];
  const double y_pixel_size = scale[1];

  GeoTransform& transform = geo_localization_.transform;

  transform.x_origin = model_x - pixel_x * x_pixel_size;
  transform.y_origin = model_y + pixel_y * y_pixel_size;

  transform.x_pixel_size = x_pixel_size;
  transform.y_pixel_size = -y_pixel_size;

  transform.x_row_offset = 0.0;
  transform.y_column_offset = 0.0;

  geo_localization_.valid = true;
}

void TiffSource::read_crs() {
  GTIF* gtif = GTIFNew(tiff_);
  if (!gtif) return;

  uint16_t model_type = 0;
  uint16_t code = 0;

  if (GTIFKeyGet(gtif, GTModelTypeGeoKey, &model_type, 0, 1) == 1) {
    if (model_type == ModelTypeProjected) {
      if (GTIFKeyGet(gtif, ProjectedCSTypeGeoKey, &code, 0, 1) == 1) {
        geo_localization_.crs.authority = "EPSG";
        geo_localization_.crs.code = static_cast<int>(code);
      }
    } else if (model_type == ModelTypeGeographic) {
        if (GTIFKeyGet(gtif, GeographicTypeGeoKey, &code, 0, 1) == 1) {
          geo_localization_.crs.authority = "EPSG";
          geo_localization_.crs.code = static_cast<int>(code);
        }
      }
  }

  GTIFFree(gtif);
}

void TiffSource::load_tile_band(uint32_t tile_start) {
  const std::size_t bytes_per_pixel = static_cast<std::size_t>(samples_per_pixel_) *
      (bits_per_sample_ / 8);
  const std::size_t row_bytes = static_cast<std::size_t>(width_) * bytes_per_pixel;
  const tmsize_t tile_bytes = TIFFTileSize(tiff_);
  const tmsize_t tile_row_bytes = TIFFTileRowSize(tiff_);
  if (tile_bytes <= 0 || tile_row_bytes <= 0)
    throw std::runtime_error("Invalid TIFF tile buffer size");

  std::vector<unsigned char> tile(static_cast<std::size_t>(tile_bytes));
  const uint32_t valid_rows = std::min(tile_height_, height_ - tile_start);
  for (uint32_t x = 0; x < width_; x += tile_width_) {
    const ttile_t index = TIFFComputeTile(tiff_, x, tile_start, 0, 0);
    if (TIFFReadEncodedTile(tiff_, index, tile.data(), tile_bytes) < 0) {
      throw std::runtime_error("TIFFReadEncodedTile failed at x=" +
          std::to_string(x) + ", y=" + std::to_string(tile_start));
    }
    const uint32_t valid_columns = std::min(tile_width_, width_ - x);
    const std::size_t copy_bytes = static_cast<std::size_t>(valid_columns) * bytes_per_pixel;
    if (copy_bytes > static_cast<std::size_t>(tile_row_bytes) ||
        (static_cast<std::size_t>(valid_rows - 1) * static_cast<std::size_t>(tile_row_bytes) + copy_bytes) > tile.size())
      throw std::runtime_error("Unexpected TIFF tile layout");
    for (uint32_t y = 0; y < valid_rows; ++y) {
      std::memcpy(tile_band_.data() + static_cast<std::size_t>(y) * row_bytes +
                      static_cast<std::size_t>(x) * bytes_per_pixel,
                  tile.data() + static_cast<std::size_t>(y) * static_cast<std::size_t>(tile_row_bytes),
                  copy_bytes);
    }
  }
  cached_tile_start_ = tile_start;
  tile_cache_valid_ = true;
}

bool TiffSource::read_next_row(unsigned char* destination, std::size_t row_size) {
  if (current_row_ >= height_) return false;

  const std::size_t expected_row_size = static_cast<std::size_t>(width_) * get_bytes_per_pixel();

  if (row_size != expected_row_size) {
    throw std::runtime_error("Invalid TIFF destination row size");
  }

  if (tiled_) {
    const uint32_t tile_start = (current_row_ / tile_height_) * tile_height_;
    if (!tile_cache_valid_ || tile_start != cached_tile_start_) {
      load_tile_band(tile_start);
    }
    const std::size_t raw_row_bytes = static_cast<std::size_t>(width_) *
        samples_per_pixel_ * (bits_per_sample_ / 8);
    const std::size_t offset = static_cast<std::size_t>(current_row_ - tile_start) * raw_row_bytes;
    std::memcpy(source_row_.data(), tile_band_.data() + offset, raw_row_bytes);
  } else if (TIFFReadScanline(tiff_, source_row_.data(), current_row_, 0) < 0) {
    throw std::runtime_error("TIFFReadScanline failed at row " + std::to_string(current_row_));
  }

  convert_row(destination);

  ++current_row_;
  return true;
}

void TiffSource::convert_row(unsigned char* destination) {
  if (samples_per_pixel_ == 4 && bits_per_sample_ == 8) {
    for (uint32_t x = 0; x < width_; ++x) {
      const std::size_t source_offset = static_cast<std::size_t>(x) * 4;
      const std::size_t destination_offset = static_cast<std::size_t>(x) * 4;

      destination[destination_offset] = source_row_[source_offset];
      destination[destination_offset + 1] = source_row_[source_offset + 1];
      destination[destination_offset + 2] = source_row_[source_offset + 2];
      destination[destination_offset + 3] = source_row_[source_offset + 3];
    }
    return;
  }

  if (samples_per_pixel_ == 3 && bits_per_sample_ == 8) {
    for (uint32_t x = 0; x < width_; ++x) {
      const std::size_t source_offset = static_cast<std::size_t>(x) * 3;
      const std::size_t destination_offset = static_cast<std::size_t>(x) * 4;

      destination[destination_offset] = source_row_[source_offset];
      destination[destination_offset + 1] = source_row_[source_offset + 1];
      destination[destination_offset + 2] = source_row_[source_offset + 2];
      destination[destination_offset + 3] = 255;
    }
    return;
  }

  // Palette TIFF: preserve the original numeric class index, not its display RGB color.
  // Alpha stays opaque; NoData (e.g. 0) must be handled separately by the caller.
  if (photometric_ == PHOTOMETRIC_PALETTE) {
    for (uint32_t x = 0; x < width_; ++x) {
      const unsigned char value = source_row_[x];
      const std::size_t offset = static_cast<std::size_t>(x) * 4;
      destination[offset] = value;
      destination[offset + 1] = value;
      destination[offset + 2] = value;
      destination[offset + 3] = 255;
    }
    return;
  }

  if (samples_per_pixel_ == 1 && bits_per_sample_ == 8) {
    for (uint32_t x = 0; x < width_; ++x) {
      unsigned char value = source_row_[x];

      if (photometric_ == PHOTOMETRIC_MINISWHITE) value = static_cast<unsigned char>(255 - value);

      const std::size_t destination_offset = static_cast<std::size_t>(x) * 4;

      destination[destination_offset] = value;
      destination[destination_offset + 1] = value;
      destination[destination_offset + 2] = value;
      destination[destination_offset + 3] = 255;
    }
    return;
  }

  const uint16_t* source16 = reinterpret_cast<const uint16_t*>(source_row_.data());

  if (samples_per_pixel_ == 4 && bits_per_sample_ == 16) {
    for (uint32_t x = 0; x < width_; ++x) {
      const std::size_t source_offset = static_cast<std::size_t>(x) * 4;
      const std::size_t destination_offset = static_cast<std::size_t>(x) * 4;

      destination[destination_offset] = static_cast<unsigned char>(source16[source_offset] >> 8);
      destination[destination_offset + 1] = static_cast<unsigned char>(source16[source_offset + 1] >> 8);
      destination[destination_offset + 2] = static_cast<unsigned char>(source16[source_offset + 2] >> 8);
      destination[destination_offset + 3] = static_cast<unsigned char>(source16[source_offset + 3] >> 8);
    }
    return;
  }

  if (samples_per_pixel_ == 3 && bits_per_sample_ == 16) {
    for (uint32_t x = 0; x < width_; ++x) {
      const std::size_t source_offset = static_cast<std::size_t>(x) * 3;
      const std::size_t destination_offset = static_cast<std::size_t>(x) * 4;

      destination[destination_offset] = static_cast<unsigned char>(source16[source_offset] >> 8);
      destination[destination_offset + 1] = static_cast<unsigned char>(source16[source_offset + 1] >> 8);
      destination[destination_offset + 2] = static_cast<unsigned char>(source16[source_offset + 2] >> 8);
      destination[destination_offset + 3] = 255;
    }
    return;
  }

  if (samples_per_pixel_ == 1 && bits_per_sample_ == 16) {
    for (uint32_t x = 0; x < width_; ++x) {
      unsigned char value = static_cast<unsigned char>(source16[x] >> 8);

      if (photometric_ == PHOTOMETRIC_MINISWHITE) value = static_cast<unsigned char>(255 - value);

      const std::size_t destination_offset = static_cast<std::size_t>(x) * 4;

      destination[destination_offset] = value;
      destination[destination_offset + 1] = value;
      destination[destination_offset + 2] = value;
      destination[destination_offset + 3] = 255;
    }
    return;
  }

  throw std::runtime_error("Unsupported TIFF pixel format");
}
