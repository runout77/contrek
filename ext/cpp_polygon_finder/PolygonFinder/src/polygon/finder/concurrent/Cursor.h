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
#include <unordered_set>
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
  std::vector<Shape*> shapes_sequence;
  std::unordered_set<Shape*> shapes_sequence_lookup;
  std::list<std::vector<Point*>> orphan_inners_;
  void traverse_outer(Part* act_part,
                      std::vector<Part*>& all_parts,
                      std::vector<Shape*>& shapes_sequence,
                      Sequence* outer_joined_polyline);
  std::vector<Sequence*> collect_inner_sequences(Sequence* outer_seq);
  void traverse_inner(Part* act_part, std::vector<Part*> &all_parts, Bounds& bounds);
  std::vector<EndPoint*> duplicates_intersection(Part& part_a, Part& part_b);
  std::vector<std::vector<Point*>> combine(std::vector<std::vector<Point*>>& seqa, std::vector<std::vector<Point*>>& seqb);
  std::vector<Shape*> connect_missings(std::vector<Shape*> shapes_sequence, std::vector<Shape*> missing_shapes);
};
