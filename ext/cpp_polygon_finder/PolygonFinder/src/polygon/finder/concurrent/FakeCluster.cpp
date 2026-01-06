/*
 * FakeCluster.cpp
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include "FakeCluster.h"

FakeCluster::FakeCluster(std::list<Polygon>& polygons, pf_Options options)
: NodeCluster(0, 0, &options), polygons(polygons) {
}
