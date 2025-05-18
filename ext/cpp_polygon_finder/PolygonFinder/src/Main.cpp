//============================================================================
// Name        : PolygonFinder.cpp
// Author      : Emanuele Cesaroni
// Version     :
// Copyright   : 2025 Emanuele Cesaroni
// Description :
//============================================================================

#include <iostream>
#include <string.h>
#include <list>
#include <map>
#include <string>
#include "polygon/finder/PolygonFinder.h"
#include "polygon/bitmaps/Bitmap.h"
#include "polygon/bitmaps/PngBitmap.h"
#include "polygon/bitmaps/FastPngBitmap.h"
#include "polygon/bitmaps/RemoteFastPngBitmap.h"
#include "polygon/matchers/Matcher.h"
#include "polygon/matchers/RGBMatcher.h"
#include "polygon/matchers/RGBNotMatcher.h"
#include "polygon/matchers/ValueNotMatcher.h"
#include "polygon/finder/optionparser.h"
#include "Tests.h"
using namespace std;

int main() {
  Tests *test_suite = new Tests;
  test_suite->test_a();

  FastPngBitmap png_bitmap("images/labyrinth.png");
  std::cout << "image_w=" << png_bitmap.w() << " image_h=" << png_bitmap.h() << std::endl;
  std::cout << "load_error=" << png_bitmap.error() << std::endl;

  std::string data_url = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+P+/HgAFhAJ/wlseKgAAAABJRU5ErkJggg==";
  data_url.erase(0, 22);
  RemoteFastPngBitmap bitmap(&data_url);
  std::cout << "image_w=" << bitmap.w() << " image_h=" << bitmap.h() << std::endl;
  std::cout << "load_error=" << bitmap.error() << std::endl;
  return 0;
}
