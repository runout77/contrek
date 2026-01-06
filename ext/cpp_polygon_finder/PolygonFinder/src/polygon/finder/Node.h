/*
 * Node.h
 *
 *  Created on: 26 nov 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <string>
#include <vector>
#include <list>
#include <map>
#include "List.h"

class NodeCluster;
struct Point {
  int x;
  int y;
  std::string toString() const {
    return "[x:" + std::to_string(x) + ",y:" + std::to_string(y) + "]";
  }
  bool operator==(const Point& other) const {
    return x == other.x && y == other.y;
  }
  Point(int x_, int y_) : x(x_), y(y_) {}
};
struct Tangent {
  Point   *point;
  int   mode;
};
struct NodeDescriptor;


class Node : public  Listable {
 public:
  static const int T_UP = 0;
  static const int T_DOWN = 1;
  static const int O = 0;
  static const int A = 1;
  static const int OMAX = 1 << 0;
  static const int OMIN = 1 << 1;
  static const int IMAX = 1 << 2;
  static const int IMIN = 1 << 3;
  static const int OCOMPLETE = OMIN | OMAX;
  static const int TURN_MAX = IMAX | OMAX;
  static const int TURN_MIN = IMIN | OMIN;
  const int TURNER[2][2] = {{OMAX, OMIN}, {TURN_MAX, TURN_MIN}};
  static const int OUTER = 0;
  static const int INNER = 1;

  std::vector<Node*> tangs[2];
  int y;
  int abs_x_index;
  int up_indexer, down_indexer;
  int tangs_count;
  char name;
  int track;
  int outer_index, inner_index;
  bool tangs_with(Node *node);
  void add_intersection(Node *other_node);
  std::vector<NodeDescriptor> tangs_sequence;
  Point* coords_entering_to(Node *enter_to, int mode, int tracking);
  Node* my_next_outer(Node *last, int versus);
  Node* my_next_inner(Node *last, int versus);
  bool track_uncomplete();
  bool track_complete();
  bool get_trackmax();

 private:
  static bool sort_min_x(Node *a, Node *b);
  static bool sort_max_x(Node *a, Node *b);

 public:
  int min_x, max_x;
  Node(int min_x, int max_x, int y, char name);
  void precalc_tangs_sequences(std::vector<Point>& points);
  bool processed = false;
};

struct NodeDescriptor {
  Node  *node;
  Tangent a;
  Tangent o;
};
