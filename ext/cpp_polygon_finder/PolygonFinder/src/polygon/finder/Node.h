/*
 * Node.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <string>
#include <vector>
#include <list>
#include <limits>
#include <algorithm>
#include <map>
#include <cstring>
#include <cstddef>
#include "List.h"

struct SmallVec {
  static constexpr int INLINE_CAP = 6;
  int  buf[INLINE_CAP];
  int* ptr = buf;
  int  sz = 0, cap = INLINE_CAP;
  int  front() const { return ptr[0]; }
  int  back()  const { return ptr[sz - 1]; }
  void push_back(int v) {
      if (sz == cap) {
          cap *= 2;
          int* np = new int[cap];
          std::memcpy(np, ptr, sz * sizeof(int));
          if (ptr != buf) delete[] ptr;
          ptr = np;
      }
      ptr[sz++] = v;
  }
  void reserve(int n) {
      if (n <= cap) return;
      int* np = new int[n];
      std::memcpy(np, ptr, sz * sizeof(int));
      if (ptr != buf) delete[] ptr;
      ptr = np; cap = n;
  }
  void clear() { sz = 0; ptr = buf; cap = INLINE_CAP; }
  unsigned int size() const { return static_cast<unsigned int>(sz); }
  int& operator[](int i) { return ptr[i]; }
  int  operator[](int i) const { return ptr[i]; }
  int* begin() { return ptr; }
  int* end()   { return ptr + sz; }
  ~SmallVec() { if (ptr != buf) delete[] ptr; }
};

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
  bool operator!=(const Point& other) const {
    return !(*this == other);
  }
  Point(int x_, int y_) : x(x_), y(y_) {}
  Point() : x(0), y(0) {}
};

class Node : public  Listable {
 public:
  static const int T_UP = -1;
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
  static const int OUTER = 0;
  static const int INNER = 1;

  int y;
  int abs_x_index;
  int up_indexer, down_indexer;
  int tangs_count;
  int track;
  int outer_index, inner_index;
  int upper_start = std::numeric_limits<int>::max();
  int upper_end   = -1;
  int lower_start = std::numeric_limits<int>::max();
  int lower_end   = -1;
  Point start_point, end_point;
  NodeCluster* cluster;
  void add_intersection(Node& other_node, int other_node_index);
  SmallVec tangs_sequence;
  Point coords_entering_to(Node *enter_to, int mode, int tracking);
  Node* my_next_outer(Node *last, int versus);
  Node* my_next_inner(Node *last, int versus);
  Node* get_tangent_node_by_virtual_index(int vitual_index);
  bool track_uncomplete();
  bool track_complete();
  bool get_trackmax();

 public:
  int min_x, max_x;
  Node(int min_x, int max_x, int y, NodeCluster* cluster, char name);
  void precalc_tangs_sequences(NodeCluster& cluster);
  bool processed = false;
  char name;
  int inner_left_index = -1;
  int inner_right_index = -1;
};
