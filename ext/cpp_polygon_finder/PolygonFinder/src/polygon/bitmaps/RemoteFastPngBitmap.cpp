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

RemoteFastPngBitmap::RemoteFastPngBitmap(std::string *dataurl) : FastPngBitmap("") {
  buffer = base64_decode(*dataurl);
  int error = decodePNG(image, width, height, buffer.empty() ? 0 : &buffer[0], (unsigned long) buffer.size(), true);
    if (error != 0) std::cout << "error: " << error << std::endl;
    this->last_red = &image[0];
    this->png_error = error;
}

RemoteFastPngBitmap::~RemoteFastPngBitmap() {
}

