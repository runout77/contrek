/*
 * ClippedPolygonFinder.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <string>
#include <vector>
#include "../PolygonFinder.h"

class ClippedPolygonFinder : public PolygonFinder {
 public:
  ClippedPolygonFinder(Bitmap *bitmap, Matcher *matcher, int bm_start_x, int bm_end_x, std::vector<std::string> *options = nullptr);
};
