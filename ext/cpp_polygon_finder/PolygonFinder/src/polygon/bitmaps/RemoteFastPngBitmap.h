/*
 * RemoteFastPngBitmap.h
 *
 *  Created on: 01 mag 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#ifndef POLYGON_BITMAPS_REMOTEFASTPNGBITMAP_H_
#define POLYGON_BITMAPS_REMOTEFASTPNGBITMAP_H_

#include "FastPngBitmap.h"
#include "Bitmap.h"
#include <vector>
#include <string>
#include <cstddef>

class RGBMatcher;

class RemoteFastPngBitmap: public FastPngBitmap {
 public:
  RemoteFastPngBitmap(std::string *dataurl);
  virtual ~RemoteFastPngBitmap();
};

#endif /* POLYGON_BITMAPS_REMOTEFASTPNGBITMAP_H_ */
