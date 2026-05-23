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
#include <memory>
#include <utility>
#include <fstream>
#include <sstream>
#include <stdexcept>
#include <limits>
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
class RawBitmap;
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
  bool strict_bounds = false;
  int connectivity_offset = 0;
  float compress_visvalingam_tolerance = 10.0;
  int number_of_tiles = 1;
  std::string get_alpha_versus() {
    return(versus == Node::A ? "a" : "o");
  }
};

struct ProcessResult {
  int groups;
  int width, height;
  std::map<std::string, double> benchmarks;
  std::list<Polygon> polygons;
  std::string named_sequence;
  std::vector<std::pair<int, int>> treemap;
  std::vector<std::unique_ptr<Point>> cloned_points_storage;

  void draw_on_bitmap(RawBitmap& canvas) const;

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
      std::cout << "\n" << polygon.bounds.to_string() <<"\n";
      counter++;
    }
  }

  void print_info() {
    for (const auto& [key, value] : benchmarks) {
      std::cout << key << ": " << value << ", ";
    }
    std::cout << std::endl;
  }

  void translate(int x) {
    for (auto& polygon : polygons) {
      for (Point* p : polygon.outer) p->x += x;
      for (const auto& seq : polygon.inner) {
        for (Point* p : seq) p->x += x;
      }
      polygon.bounds.min_x += x;
      polygon.bounds.max_x += x;
    }
  }

  ProcessResult* clone() const {
    ProcessResult* new_res = new ProcessResult();
    new_res->groups = this->groups;
    new_res->width = this->width;
    new_res->height = this->height;
    new_res->benchmarks = this->benchmarks;
    new_res->named_sequence = this->named_sequence;
    new_res->treemap = this->treemap;

    size_t estimated_points = 0;
    for (const auto& poly : this->polygons) {
      estimated_points += poly.outer.size();
      for (const auto& seq : poly.inner) estimated_points += seq.size();
    }
    new_res->cloned_points_storage.reserve(estimated_points);

    for (const auto& poly : this->polygons) {
      Polygon new_poly;
      // bounds
      new_poly.bounds = poly.bounds;
      // outer
      for (const Point* p : poly.outer) {
        if (p) {
          new_res->cloned_points_storage.push_back(std::make_unique<Point>(p->x, p->y));
          new_poly.outer.push_back(new_res->cloned_points_storage.back().get());
        }
      }
      // inner
      for (const auto& seq : poly.inner) {
        std::vector<Point*> new_seq;
        for (const Point* p : seq) {
          if (p) {
            new_res->cloned_points_storage.push_back(std::make_unique<Point>(p->x, p->y));
            new_seq.push_back(new_res->cloned_points_storage.back().get());
          }
        }
        new_poly.inner.push_back(new_seq);
      }
      new_res->polygons.push_back(new_poly);
    }
    return new_res;
  }

  std::string to_svg() const {
    std::vector<std::string> lines;
    lines.push_back(
      "<svg xmlns=\"http://www.w3.org/2000/svg\" "
      "width=\"" + std::to_string(width) +
      "\" height=\"" + std::to_string(height) + "\">");
    for (const auto& poly : polygons) {
      { // outer
        std::ostringstream pts;
        bool first = true;
        for (const Point* p : poly.outer) {
          if (!p) continue;
          if (!first)
              pts << " ";
          first = false;
          pts << p->x << "," << p->y;
        }
        lines.push_back(
          "<polygon points=\"" + pts.str() +
          "\" fill=\"none\" stroke=\"red\" stroke-width=\"1\"/>");
      }
      // inner
      for (const auto& sequence : poly.inner) {
        if (sequence.empty()) continue;
        std::ostringstream pts;
        bool first = true;
        for (const Point* p : sequence) {
          if (!p) continue;
          if (!first) pts << " ";
          first = false;
          pts << p->x << "," << p->y;
        }
        lines.push_back(
          "<polygon points=\"" + pts.str() +
          "\" fill=\"none\" stroke=\"green\" stroke-width=\"1\"/>");
      }
    }
    lines.push_back("</svg>");
    std::ostringstream result;
    for (size_t i = 0; i < lines.size(); ++i) {
      result << lines[i];
      if (i + 1 < lines.size()) result << "\n";
    }
    return result.str();
  }

  void save_svg(const std::string& filename) const {
    std::ofstream file(filename);
    if (!file.is_open()) {
      throw std::runtime_error("Unable to open SVG file: " + filename);
    }
    file << to_svg();
    file.close();
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
