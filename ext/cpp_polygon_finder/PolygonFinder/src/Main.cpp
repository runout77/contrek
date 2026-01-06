//============================================================================
// Name        : PolygonFinder.cpp
// Author      : Emanuele Cesaroni
// Version     :
// Copyright   : 2025 Emanuele Cesaroni
// Description :
//============================================================================

#include <string.h>
#include <iostream>
#include <list>
#include <map>
#include <string>
#include "polygon/finder/PolygonFinder.h"
#include "polygon/bitmaps/Bitmap.h"
#include "polygon/bitmaps/FastPngBitmap.h"
#include "polygon/bitmaps/RemoteFastPngBitmap.h"
#include "polygon/matchers/Matcher.h"
#include "polygon/matchers/RGBMatcher.h"
#include "polygon/matchers/RGBNotMatcher.h"
#include "polygon/matchers/ValueNotMatcher.h"
#include "polygon/finder/optionparser.h"
#include "Tests.h"
#include "polygon/CpuTimer.h"

int main() {
  CpuTimer cpu_timer;
  Tests test_suite;
  cpu_timer.start();

  // test_suite.test_a();
  // test_suite.test_b();
  // test_suite.test_c();
  // test_suite.test_d();
  test_suite.test_e();
  std::cout << "compute time =" << cpu_timer.stop() << std::endl;

/*
  FastPngBitmap png_bitmap("images/labyrinth.png");
  std::cout << "image_w=" << png_bitmap.w() << " image_h=" << png_bitmap.h() << std::endl;
  std::cout << "load_error=" << png_bitmap.error() << std::endl;

  std::string data_url = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+P+/HgAFhAJ/wlseKgAAAABJRU5ErkJggg==";
  data_url.erase(0, 22);
  RemoteFastPngBitmap bitmap(&data_url);
  std::cout << "image_w=" << bitmap.w() << " image_h=" << bitmap.h() << std::endl;
  std::cout << "load_error=" << bitmap.error() << std::endl;
*/
  return 0;
}
