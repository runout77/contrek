/*
 * RemoteFastPngBitmap.cpp
 *
 *  Created on: 01 mag 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include "RemoteFastPngBitmap.h"
#include <cstring>
#include <iostream>
#include <vector>
#include <fstream>
#include <cstddef>
#include <typeinfo>
#include <string>
#include "../matchers/RGBMatcher.h"
#include "../matchers/RGBNotMatcher.h"
#include "spng.h"

RemoteFastPngBitmap::RemoteFastPngBitmap(std::string *dataurl) : FastPngBitmap("") {
    buffer = base64_decode(*dataurl);
    if (buffer.empty()) {
      this->png_error = 1;
      return;
    }
    spng_ctx *ctx = spng_ctx_new(0);
    spng_set_png_buffer(ctx, buffer.data(), buffer.size());
    struct spng_ihdr ihdr;
    int error = spng_get_ihdr(ctx, &ihdr);
    if (!error) {
      this->width = ihdr.width;
      this->height = ihdr.height;
      size_t out_size;  // RGBA8 dimension
      spng_decoded_image_size(ctx, SPNG_FMT_RGBA8, &out_size);
      this->image.resize(out_size);
      error = spng_decode_image(ctx, image.data(), out_size, SPNG_FMT_RGBA8, SPNG_DECODE_TRNS);
    }
    if (error != 0) {
      std::cout << "spng error: " << spng_strerror(error) << std::endl;
    }
    this->png_error = error;
    spng_ctx_free(ctx);
}

RemoteFastPngBitmap::~RemoteFastPngBitmap() {
}
