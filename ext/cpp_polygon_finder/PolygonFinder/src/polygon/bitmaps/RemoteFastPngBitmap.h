/*
 * RemoteFastPngBitmap.h
 *
 *  Created on: 01 mag 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
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
