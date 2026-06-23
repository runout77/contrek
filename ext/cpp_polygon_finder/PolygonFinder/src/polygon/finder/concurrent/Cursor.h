/*
 * Cursor.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <list>
#include <vector>
#include <unordered_set>
#include "../Primitives.h"
#include "Sequence.h"
#include "Cluster.h"
#include "Shape.h"
#include "Part.h"

class Cursor {
 public:
  Cursor(Cluster& cluster, Shape* shape);
  Sequence join_outers();
  std::vector<InnerPolyline*> join_inners(bool treemap);
  std::list<InnerPolyline*> orphan_inners() { return orphan_inners_; }
  const std::vector<Shape*>& shapes_sequence() const { return shapes_sequence_; }

 private:
  Cluster& cluster;
  Shape* shape;
  std::vector<Shape*> shapes_sequence_;
  std::unordered_set<Shape*> shapes_sequence_lookup;
  std::list<InnerPolyline*> orphan_inners_;
  void traverse_outer(Part* act_part,
                      std::vector<Part*>& all_parts,
                      std::vector<Shape*>& shapes_sequence,
                      Sequence& outer_joined_polyline);
  void traverse_inner(Part* act_part, std::vector<Part*> &all_parts, Bounds& bounds, std::vector<EndPoint*>& tracked_end_points);
  std::vector<Shape*> connect_missings(std::vector<Shape*> shapes_sequence, std::vector<Shape*> missing_shapes);
  void mark_children(std::vector<EndPoint*>& end_points, const Polyline* outer_polyline, InnerPolyline* inner_polyline);
};
