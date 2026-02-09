/*
 * RemoteFastPngBitmap.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <vector>
#include <string>
#include <cstddef>
#include "FastPngBitmap.h"
#include "Bitmap.h"

class RGBMatcher;

class RemoteFastPngBitmap: public FastPngBitmap {
 public:
  explicit RemoteFastPngBitmap(std::string *dataurl);
  virtual ~RemoteFastPngBitmap();
};
