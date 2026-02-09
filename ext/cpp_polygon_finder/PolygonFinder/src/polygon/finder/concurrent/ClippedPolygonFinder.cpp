/*
 * ClippedPolygonFinder.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */
#include <string>
#include <vector>
#include "ClippedPolygonFinder.h"

ClippedPolygonFinder::ClippedPolygonFinder(Bitmap *bitmap, Matcher *matcher, int bitmap_start_x, int bitmap_end_x, std::vector<std::string> *options)
: PolygonFinder(bitmap, matcher, nullptr, options, bitmap_start_x, bitmap_end_x) {
}
