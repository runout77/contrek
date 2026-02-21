/*
 * PolygonFinder.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <list>
#include <vector>
#include <ctime>
#include <string>
#include <map>
#include <iostream>
#include <utility>
#include "../bitmaps/Bitmap.h"
#include "NodeCluster.h"
#include "Node.h"
#include "Polygon.h"
#include "Node.h"
#include "../CpuTimer.h"

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
  bool named_sequences = false;
  bool bounds = false;
  int connectivity_offset = 0;
  float compress_visvalingam_tolerance = 10.0;
  int number_of_tiles = 1;
  std::string get_alpha_versus() {
    return(versus == Node::A ? "a" : "o");
  }
};
struct ProcessResult {
  int groups;
  std::map<std::string, double> benchmarks;
  std::list<Polygon> polygons;
  std::string named_sequence;
  std::vector<std::pair<int, int>> treemap;

  void print_polygons() {
    int counter = 0;
    for (const auto& polygon : polygons) {
      std::cout << counter << " - " << "outer" << "\n";
      for (const Point* p : polygon.outer) std::cout << p->toString();
      bool first = true;
      for (const auto& seq : polygon.inner) {
        if (!first) std::cout << "\n";
        first = false;
        for (const Point* p : seq) std::cout << p->toString();
      }
      std::cout << "\n";
      counter++;
    }
  }

  void print_info() {
    for (const auto& [key, value] : benchmarks) {
      std::cout << key << ": " << value << ", ";
    }
    std::cout << std::endl;
  }
};

class PolygonFinder {
 protected:
  int start_x;
  int end_x;

 private:
  Bitmap *source_bitmap;
  Matcher *matcher;
  RGBMatcher* rgb_matcher;
  NodeCluster *node_cluster;
  pf_Options options;
  std::map<std::string, double> reports;
  void scan();
  CpuTimer cpu_timer;

  template <typename M, typename F>
  void run_loop(M* specific_matcher, F&& fetch_color, int offset) {
    int img_h = this->source_bitmap->h();
    int bpp = this->source_bitmap->get_bytes_per_pixel();
    for (int y = 0; y < img_h; y++) {
      const unsigned char* row_ptr = this->source_bitmap->get_row_ptr(y);
      const unsigned char* p = row_ptr + (this->start_x * bpp);
      int min_x = 0;
      bool matching = false;
      unsigned char last_red_value = 0;
      for (int x = this->start_x; x < this->end_x; x++) {
        unsigned int color = fetch_color(p);
        unsigned char current_val = p[0];
        p += bpp;
        if (specific_matcher->match(color)) {
          if (!matching) {
            min_x = x;
            last_red_value = current_val;
            matching = true;
          }
          if (x == this->end_x - 1) {
            this->node_cluster->add_node(min_x, x, y, last_red_value, offset);
            matching = false;
          }
        } else if (matching) {
          this->node_cluster->add_node(min_x, x - 1, y, last_red_value, offset);
          matching = false;
        }
      }
    }
  }

 public:
  PolygonFinder(Bitmap *bitmap,
                Matcher *matcher,
                Bitmap *test_bitmap,
                std::vector<std::string> *options = nullptr,
                int start_x = 0,
                int end_x = -1);
  ProcessResult* process_info();
  std::list<ShapeLine*> *get_shapelines();
  virtual ~PolygonFinder();
  const NodeCluster* get_cluster() const { return this->node_cluster; }
};
