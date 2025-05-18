/*
 * Tests.cpp
 *
 *  Created on: 16 feb 2021
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include "Tests.h"
#include <iostream>
#include <string.h>
#include <list>
#include <map>
#include <vector>
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
using namespace std;

Tests::Tests() {
}

Tests::~Tests() {
}

void Tests::test_a()
{ string chunk =
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
  for (std::list<std::map<std::string, std::list<std::list<Point*>*>>>::iterator x = o->polygons.begin(); x != o->polygons.end(); ++x)
  { for (std::list<Point*>::iterator y = (*x)["outer"].front()->begin(); y != (*x)["outer"].front()->end(); ++y)
    {  array_compare.push_back((*y)->x);
       array_compare.push_back((*y)->y);
    }
    if (outer_array != array_compare) throw;
    array_compare.clear();

    for (std::list<std::list<Point*>*>::iterator z = (*x)["inner"].begin(); z != (*x)["inner"].end(); ++z)
    { for (std::list<Point*>::iterator y = (*z)->begin(); y != (*z)->end(); ++y)
      { array_compare.push_back((*y)->x);
        array_compare.push_back((*y)->y);
      }
    }
    if (inner_array != array_compare) throw;
  }
}

