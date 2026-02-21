/*
 * NodeCluster.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <list>
#include <vector>
#include <deque>
#include <map>
#include <string>
#include <utility>
#include "PolygonFinder.h"
#include "Lists.h"
#include "RectBounds.h"
#include "Polygon.h"

class Node;
struct Point;
struct pf_Options;

class NodeCluster {
 private:
  void plot_node(std::vector<Point*>& sequence_coords, Node *node, Node *start_node, int versus, RectBounds& bounds);
  void plot_inner_node(std::vector<Point*>& sequence_coords, Node *node, int versus, Node *stop_at, Node *start_node);
  std::vector<Node*> plot_sequence;
  List *inner_plot;
  List *inner_new;
  int versus_inverter[2];
  int count = 0;
  int nodes;
  int width;

 public:
  pf_Options *options;
  std::vector<std::pair<int, int>> treemap;  // [a,b] a = index of parent outer, b = index of inner of parent outer
  std::pair<int, int> test_in_hole_a(Node* node);
  std::pair<int, int> test_in_hole_o(Node* node);
  std::vector<std::deque<Node>> vert_nodes;
  void compress_coords(std::list<Polygon>& polygons, pf_Options options);
  List *root_nodes;
  int height;
  std::list<Polygon> polygons;
  NodeCluster(int h, int w, pf_Options *options);
  virtual ~NodeCluster();
  Node* add_node(int min_x, int max_x, int y, char name, int offset);
  void calc_root_nodes();
  void build_tangs_sequence();
  void plot(int versus);
  Lists lists;
  std::list<Node*>::iterator exam(std::list<Node*>::iterator inode, Node *node, Node *father, Node *root_node);
  std::vector<std::vector<Node*>> sequences;
};
