/*
 * ClippedPolygonFinder.h
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <string>
#include <vector>
#include "../PolygonFinder.h"

class ClippedPolygonFinder : public PolygonFinder {
 public:
  ClippedPolygonFinder(Bitmap *bitmap, Matcher *matcher, int bm_start_x, int bm_end_x, std::vector<std::string> *options = nullptr);
};
