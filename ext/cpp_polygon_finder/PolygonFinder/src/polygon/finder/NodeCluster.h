/*
 * NodeCluster.h
 *
 *  Created on: 26 nov 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#ifndef POLYGON_FINDER_NODECLUSTER_H_
#define POLYGON_FINDER_NODECLUSTER_H_
#include <list>
#include <vector>
#include <map>
#include <string>
#include "PolygonFinder.h"
#include "Lists.h"

class Node;
struct Point;
struct pf_Options;

class NodeCluster {
 private:
  void plot_node(Node *node, Node *start_node, int versus);
  void plot_inner_node(Node *node, int versus, Node *stop_at, Node *start_node);
  std::list<Node*> *plot_sequence;
  List *inner_plot;
  std::list<Point*> *sequence_coords;
  List *inner_new;
  int versus_inverter[2];
  int count = 0;
  int nodes;
  pf_Options *options;

 public:
  std::list<int*> treemap;
  int *test_in_hole_a(Node *node);
  int *test_in_hole_o(Node *node);
  std::vector<Node*> *vert_nodes;
  void list_track(Node *node, std::list<Node*> *list);
  void list_delete(Node *node, std::list<Node*> *list);
  bool list_present(Node *node, std::list<Node*> *list);
  void compress_coords(pf_Options options);
  List *root_nodes;
  int height;
  std::list<std::map<std::string, std::list<std::list<Point*>*>>> polygons;
  NodeCluster(int h, pf_Options *options);
  virtual ~NodeCluster();
  void add_node(Node *node);
  void calc_root_nodes();
  void build_tangs_sequence();
  void plot(int versus);
  Lists lists;
  std::list<Node*>::iterator exam(std::list<Node*>::iterator inode, Node *node, Node *father, Node *root_node);
  std::list<Point*>* get_coords();
  std::list<std::list<Node*>*> *sequences;
};

#endif /* POLYGON_FINDER_NODECLUSTER_H_ */
