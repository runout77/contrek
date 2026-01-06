/*
 * ClippedPolygonFinder.cpp
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */
#include <string>
#include <vector>
#include "ClippedPolygonFinder.h"

ClippedPolygonFinder::ClippedPolygonFinder(Bitmap *bitmap, Matcher *matcher, int bitmap_start_x, int bitmap_end_x, std::vector<std::string> *options)
: PolygonFinder(bitmap, matcher, nullptr, options, bitmap_start_x, bitmap_end_x) {
}
