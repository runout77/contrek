/*
 * FakeCluster.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include "FakeCluster.h"

FakeCluster::FakeCluster(std::list<Polygon>& polygons, pf_Options options)
: NodeCluster(0, 0, &options), polygons(polygons) {
}
