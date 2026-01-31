/*
 * Tests.cpp
 *
 *  Created on: 16 feb 2021
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include "Tests.h"
#include <string.h>
#include <iostream>
#include <list>
#include <map>
#include <vector>
#include <string>
#include "polygon/finder/PolygonFinder.h"
#include "polygon/finder/concurrent/ClippedPolygonFinder.h"
#include "polygon/bitmaps/Bitmap.h"
#include "polygon/bitmaps/FastPngBitmap.h"
#include "polygon/bitmaps/RemoteFastPngBitmap.h"
#include "polygon/matchers/Matcher.h"
#include "polygon/matchers/RGBMatcher.h"
#include "polygon/matchers/RGBNotMatcher.h"
#include "polygon/matchers/ValueNotMatcher.h"
#include "polygon/finder/optionparser.h"
#include "polygon/finder/concurrent/Finder.h"
#include "polygon/finder/concurrent/Sequence.h"
#include "polygon/finder/concurrent/Position.h"
#include "polygon/finder/Polygon.h"

void Tests::test_a()
{ std::string chunk =
      "0000000000000000"\
      "00000000000B0000"\
      "000000AAAAAA0000"\
      "000000BB00FF0000"\
      "000000CC00EE0000"\
      "000000DDDDDD0000"\
      "0000000000000000";

  std::vector<std::string> arguments = {"--versus=a", "--compress_uniq", "--treemap"};
  ValueNotMatcher matcher('0');
  Bitmap b(chunk, 16);
  PolygonFinder pl(&b, &matcher, nullptr, &arguments);
  ProcessResult *o = pl.process_info();
  std::vector<int> outer_array{11, 1, 6, 2, 6, 3, 6, 4, 6, 5, 11, 5, 11, 4, 11, 3, 11, 2, 11, 1};
  std::vector<int> inner_array{7, 3, 10, 3, 10, 4, 7, 4};
  std::vector<int> array_compare;

  for (const auto& x : o->polygons)
  { for (const Point* p : x.outer) {
      array_compare.push_back(p->x);
      array_compare.push_back(p->y);
    }
    if (outer_array != array_compare) throw std::runtime_error("Wrong OUTER results!");
    array_compare.clear();
    for (const auto& z : x.inner)
    { for (const Point* y : z)
      { array_compare.push_back(y->x);
        array_compare.push_back(y->y);
      }
    }
    if (inner_array != array_compare) throw std::runtime_error("Wrong INNER results!");
  }
  delete o;
}

void Tests::test_b()
{ std::string chunk =
//    "0123456789012345"
      "  XXXXXXXXXXX   "\
      "  XX       XX   "\
      "  XX       XX   "\
      "  XX       XX   "\
      "  XXXXXXXXXXX   ";

  std::vector<std::string> arguments = {"--versus=o", "--number_of_tiles=2", "--compress_uniq", "--compress_linear", "--treemap"};
  ValueNotMatcher matcher(' ');
  Bitmap b(chunk, 16);
  Finder concurrentFinder(2, &b, &matcher, &arguments);
  ProcessResult *pro = concurrentFinder.process_info();
  pro->print_polygons();
  delete pro;
}

void Tests::test_c()
{ Sequence sequence;
  Point* p1 = new Point({1, 1});
  Point* p2 = new Point({2, 2});
  Point* p3 = new Point({3, 3});

  Hub* hub = new Hub(4, 0, 3);

  Position* pos1 = new Position(hub, p1);
  Position* pos2 = new Position(hub, p2);
  Position* pos3 = new Position(hub, p3);

  if (sequence.size != 0) throw std::runtime_error("Wrong initial sequence size");
  sequence.add(pos1);
  sequence.add(pos2);
  sequence.add(pos3);
  if (sequence.size != 3) throw std::runtime_error("Wrong sequence size");

  // iterator() initially gives head
  Point* head = sequence.head->payload;
  if (head != p1) throw std::runtime_error("Wrong head");
  if (sequence.iterator()->payload != p1) throw std::runtime_error("Wrong iterator to head");
  if (sequence.iterator() != pos1) throw std::runtime_error("Wrong iterator to head");
  // forward!
  sequence.forward();
  if (sequence.iterator()->payload != p2) throw std::runtime_error("Wrong iterator to position 2");
  if (sequence.iterator() != pos2) throw std::runtime_error("Wrong iterator to position 2");
  // forward!
  sequence.forward();
  if (sequence.iterator()->payload != p3) throw std::runtime_error("Wrong iterator to position 3");
  if (sequence.iterator() != pos3) throw std::runtime_error("Wrong iterator to position 3");

  // forward returns nullptr when no more items are present
  sequence.forward();
  if (sequence.iterator() != nullptr) throw std::runtime_error("Wrong iterator to end of list");

  // rewind
  sequence.rewind();
  if (sequence.iterator()->payload != p1) throw std::runtime_error("Wrong iterator to head");

  delete p1;
  delete p2;
  delete p3;

  delete hub;

  delete pos1;
  delete pos2;
  delete pos3;
}

void Tests::test_d()
{ CpuTimer cpu_timer;
  cpu_timer.start();
  FastPngBitmap png_bitmap("../images/sample_10240x10240.png");
  // FastPngBitmap png_bitmap("images/labyrinth.png");
  std::cout << "image_w=" << png_bitmap.w() << " image_h=" << png_bitmap.h() << std::endl;
  std::cout << "immagine =" << cpu_timer.stop() << std::endl;

  int color = png_bitmap.value_at(0, 0);
  std::cout << "color =" << color << std::endl;
  RGBNotMatcher not_matcher(color);

  std::vector<std::string> arguments = {"--versus=a", "--compress_uniq"};
  PolygonFinder pl(&png_bitmap, &not_matcher, nullptr, &arguments);
  ProcessResult *o = pl.process_info();
  o->print_info();
  delete o;
}

void Tests::test_e()
{ CpuTimer cpu_timer;
  cpu_timer.start();
  FastPngBitmap png_bitmap("../images/sample_10240x10240.png");
  // FastPngBitmap png_bitmap("images/sample_1024x1024.png");
  std::cout << "image reading time =" << cpu_timer.stop() << std::endl;

  int color = png_bitmap.rgb_value_at(0, 0);
  std::cout << "color = " << color << std::endl;
  RGBNotMatcher not_matcher(color);

  std::vector<std::string> arguments = {"--versus=a", "--compress_uniq", "--number_of_tiles=2"};
  Finder pl(2, &png_bitmap, &not_matcher, &arguments);
  ProcessResult *o = pl.process_info();
  o->print_info();
  std::cout << "polygons =" << o->groups << std::endl;
  delete o;
}

void Tests::test_f()
{ FastPngBitmap png_bitmap("../images/labyrinth.png");
  std::cout << "image_w=" << png_bitmap.w() << " image_h=" << png_bitmap.h() << std::endl;
  std::cout << "load_error=" << png_bitmap.error() << std::endl;

  std::string data_url = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+P+/HgAFhAJ/wlseKgAAAABJRU5ErkJggg==";
  data_url.erase(0, 22);
  RemoteFastPngBitmap bitmap(&data_url);
  std::cout << "image_w=" << bitmap.w() << " image_h=" << bitmap.h() << std::endl;
  std::cout << "load_error=" << bitmap.error() << std::endl;
}
