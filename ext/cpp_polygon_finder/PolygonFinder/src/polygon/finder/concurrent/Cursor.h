/*
 * Cursor.h
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <list>
#include <vector>
#include "Sequence.h"
#include "Cluster.h"
#include "Shape.h"
#include "Part.h"

struct Bounds {
  int min;
  int max;
};

class Cursor {
 public:
  Cursor(Cluster& cluster, Shape* shape);
  virtual ~Cursor();
  Sequence* join_outers();
  std::vector<Sequence*> join_inners(Sequence* outer_seq);
  std::list<std::vector<Point*>> orphan_inners() { return orphan_inners_; }

 private:
  Cluster& cluster;
  Shape* shape;
  std::vector<Sequence*> allocated_sequences;
  std::vector<Polyline*> polylines_sequence;
  std::list<std::vector<Point*>> orphan_inners_;
  void traverse_outer(Part* act_part,
                      std::vector<Part*>& all_parts,
                      std::vector<Polyline*>& polylines,
                      std::vector<Shape*>& shapes,
                      Sequence* outer_joined_polyline,
                      int& counter);
  std::vector<Sequence*> collect_inner_sequences(Sequence* outer_seq);
  void traverse_inner(Part* act_part, std::vector<Part*> &all_parts, Bounds& bounds);
  std::vector<Point*> duplicates_intersection(const Part& part_a, const Part& part_b);
  std::vector<std::vector<Point*>> combine(std::vector<std::vector<Point*>>& seqa, std::vector<std::vector<Point*>>& seqb);
};
