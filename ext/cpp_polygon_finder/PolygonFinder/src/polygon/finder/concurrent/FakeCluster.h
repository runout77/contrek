/*
 * FakeCluster.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <list>
#include "../NodeCluster.h"

class FakeCluster : public NodeCluster {
 public:
  std::list<Polygon>& polygons;
  FakeCluster(std::list<Polygon>& polygons, pf_Options options);
};
