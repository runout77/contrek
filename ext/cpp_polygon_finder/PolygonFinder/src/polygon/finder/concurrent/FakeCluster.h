/*
 * FakeCluster.h
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <list>
#include "../NodeCluster.h"

class FakeCluster : public NodeCluster {
 public:
  std::list<Polygon>& polygons;
  FakeCluster(std::list<Polygon>& polygons, pf_Options options);
};
