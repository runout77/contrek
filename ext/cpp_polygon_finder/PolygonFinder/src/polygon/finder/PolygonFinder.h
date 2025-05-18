/*
 * PolygonFinder.h
 *
 *  Created on: 24 nov 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#ifndef POLYGONFINDER_H_
#define POLYGONFINDER_H_

#include <list>
#include <vector>
#include "Node.h"
#include <ctime>
#include <string>
#include <map>

class Bitmap;
class Matcher;
class RGBMatcher;
class NodeCluster;
class Node;
struct Point;

struct ShapeLine {
  int start_x, end_x, y;
};

struct pf_Options {
  int versus = Node::A;
  bool treemap = false;
  bool compress_uniq = false;
  bool compress_linear = false;
  bool compress_visvalingam = false;
  float compress_visvalingam_tolerance = 10.0;
};
struct ProcessResult {
  int groups;
  std::map<std::string, double> benchmarks;
  std::list<std::map<std::string, std::list<std::list<Point*>*>>> polygons;
  std::string named_sequence;
  std::list<int*> treemap;
};

class PolygonFinder {
 private:
  Bitmap *source_bitmap;
  Matcher *matcher;
  NodeCluster *node_cluster;
  pf_Options options;
  std::map<std::string, double> reports;
  void start_timer();
  double end_timer();
  void scan();
  std::clock_t timer_start, timer_end;
  void sanitize_options(std::vector<std::string> *incoming_options);

 public:
  PolygonFinder(Bitmap *bitmap, Matcher *matcher, Bitmap *test_bitmap, std::vector<std::string> *options = nullptr);
  ProcessResult* process_info();
  std::list<ShapeLine*> *get_shapelines();
  virtual ~PolygonFinder();
};




#endif /* POLYGONFINDER_H_ */
