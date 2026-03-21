/*
 * Tests.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "Tests.h"
#include <string.h>
#include <iostream>
#include <list>
#include <map>
#include <vector>
#include <string>
#include <cstring>
#include <algorithm>
#include <cstdio>
#include "polygon/finder/PolygonFinder.h"
#include "polygon/finder/concurrent/ClippedPolygonFinder.h"
#include "polygon/bitmaps/Bitmap.h"
#include "polygon/bitmaps/FastPngBitmap.h"
#include "polygon/bitmaps/RawBitmap.h"
#include "polygon/bitmaps/RemoteFastPngBitmap.h"
#include "polygon/bitmaps/spng.h"
#include "polygon/matchers/Matcher.h"
#include "polygon/matchers/RGBMatcher.h"
#include "polygon/matchers/RGBNotMatcher.h"
#include "polygon/matchers/ValueNotMatcher.h"
#include "polygon/finder/optionparser.h"
#include "polygon/finder/concurrent/Finder.h"
#include "polygon/finder/concurrent/HorizontalMerger.h"
#include "polygon/finder/concurrent/VerticalMerger.h"
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
  // o->print_polygons();
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
  std::cout << "image reading time =" << cpu_timer.stop() << std::endl;

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
  std::cout << "polygons = " << o->groups << std::endl;
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

void Tests::test_g()
{ RawBitmap raw_bitmap;
  raw_bitmap.define(50, 50, 4);

  // draw a polygon start_x = 5, start_y = 4, end_x = 8, end_y = 5
  for (int y : {4, 5}) {
    for (int x = 5; x <= 8; ++x) {
      raw_bitmap.draw_pixel(x, y, 1, 0, 0);
    }
  }

  int color = raw_bitmap.rgb_value_at(0, 0);
  std::cout << "color = " << color << std::endl;
  RGBNotMatcher not_matcher(color);

  std::vector<std::string> arguments = {"--versus=a", "--compress_uniq", "--number_of_tiles=2"};
  Finder pl(2, &raw_bitmap, &not_matcher, &arguments);
  ProcessResult *o = pl.process_info();
  // o->print_info();
  // o->print_polygons();
  std::cout << "polygons = " << o->groups << std::endl;
  delete o;
}

void Tests::test_h()
{ std::string left =
              "0000000000" \
              "0000000000" \
              "00        " \
              "00        " \
              "00        " \
              "00        " \
              "00        " \
              "0000000000" \
              "0000000000";
  std::vector<std::string> arguments = {"--versus=a", "--compress_uniq"};
  ValueNotMatcher matcher(' ');
  Bitmap b_left(left, 10);
  PolygonFinder pl_left(&b_left, &matcher, nullptr, &arguments);
  ProcessResult *left_result = pl_left.process_info();

  std::string right =
              "0000000000" \
              "0000000000" \
              "      0000" \
              "      0000" \
              "      0000" \
              "      0000" \
              "      0000" \
              "0000000000" \
              "0000000000";
  Bitmap b_right(right, 10);
  PolygonFinder pl_right(&b_right, &matcher, nullptr, &arguments);
  ProcessResult *right_result = pl_right.process_info();

  std::vector<std::string> merger_arguments = {};
  HorizontalMerger hmerger(1, &arguments);
  hmerger.add_tile(*left_result);
  hmerger.add_tile(*right_result);
  ProcessResult *merged_result = hmerger.process_info();
  merged_result->print_polygons();

  delete merged_result;
  delete left_result;
  delete right_result;
}

/* In this example, PNG data is read by streaming into a user-defined buffer height.
  Contrek scans each stripe and extracts the polygons. Finally, it merges all
  polygons from every stripe as if they had been read from a single image and saves
  the result polygons on a png image.
  This approach allows for processing large PNG files on systems where memory
  would otherwise be insufficient.
*/
void stream_png_image(const std::string& filepath, uint32_t stripe_height) {
    std::vector<ProcessResult*> result_clones;
    std::vector<std::string> varguments = {};
    VerticalMerger vmerger(0, &varguments);

    // opens image to stream
    FILE* fp = fopen(filepath.c_str(), "rb");
    if (!fp) {
      std::cerr << "Unable open file: " << filepath << std::endl;
      return;
    }

    // exams image
    spng_ctx *ctx = spng_ctx_new(0);
    spng_set_png_file(ctx, fp);
    struct spng_ihdr ihdr;
    if (spng_get_ihdr(ctx, &ihdr)) {
      fclose(fp);
      spng_ctx_free(ctx);
      return;
    }
    uint32_t total_width = ihdr.width;
    uint32_t total_height = ihdr.height;

    // allocates stripe buffer
    RawBitmap stripe_bitmap;
    stripe_bitmap.define(total_width, stripe_height, 4, true);
    RGBNotMatcher not_matcher(-1);

    if (spng_decode_image(ctx, NULL, 0, SPNG_FMT_RGBA8, SPNG_DECODE_PROGRESSIVE)) {
      fclose(fp);
      spng_ctx_free(ctx);
      return;
    }

    size_t row_size = static_cast<size_t>(total_width) * 4;
    // main strpes loop
    for (uint32_t current_y_offset = 0; current_y_offset < total_height; current_y_offset += stripe_height) {
      int uncovered_height = total_height - current_y_offset;

      // copy previous last line to the next new one (each contigue stripe must share one pixel scanline)
      if (current_y_offset > 0) {
        unsigned char* last_row_prev = const_cast<unsigned char*>(stripe_bitmap.get_row_ptr(stripe_height - 1));
        unsigned char* first_row_curr = const_cast<unsigned char*>(stripe_bitmap.get_row_ptr(0));
        std::memcpy(first_row_curr, last_row_prev, row_size);
      }
      // clears the part of the stripe wont be overwritten by png data
      if (uncovered_height < stripe_height)
      { stripe_bitmap.draw_filled_rectangle(0, 1, total_width, stripe_height - 1, 255, 255, 255);
      }
      // decoding data directly in the stripe buffer
      uint32_t lines_to_read = std::min(stripe_height, total_height - current_y_offset);
      for (uint32_t y = (current_y_offset == 0 ? 0 : 1); y < lines_to_read; y++) {
        unsigned char* row_ptr = const_cast<unsigned char*>(stripe_bitmap.get_row_ptr(y));
        int ret = spng_decode_row(ctx, row_ptr, row_size);
        if (ret != 0 && ret != SPNG_EOI) break;
      }
      // stripe contour tracing
      std::vector<std::string> finder_arguments = {
        "--versus=a",
        "--strict_bounds"  // <- this option is strictly needed when working with vertical merger
      };
      PolygonFinder polygon_finder(&stripe_bitmap, &not_matcher, nullptr, &finder_arguments);
      ProcessResult *result = polygon_finder.process_info();
      if (result) {
        std::cout << "Founds polygons: " << result->groups << std::endl;
        ProcessResult* safe_result = result->clone();
        result_clones.push_back(safe_result);
        vmerger.add_tile(*safe_result);
        delete result;
      }
    }

    std::cout << "Merging polygons ..." << std::endl;
    ProcessResult *merged_result = vmerger.process_info();
    std::cout << "Founds total polygons: " << merged_result->groups << std::endl;

    if (merged_result) {
      RawBitmap full_bitmap;
      full_bitmap.define(total_width, total_height, 4, true);
      full_bitmap.fill(255, 255, 255);
      merged_result->draw_on_bitmap(full_bitmap);
      std::cout << "Saving whole png ..." << std::endl;
      if (full_bitmap.save_to_png("whole.png")) {
        std::cout << "Png saved!" << std::endl;
      }
    }
    delete merged_result;
    // frees memory
    for (auto c : result_clones) {
      delete c;
    }
    spng_ctx_free(ctx);
    fclose(fp);
}

void Tests::test_i() {
  stream_png_image("../images/graphs_1024x1024.png", 300);
}
