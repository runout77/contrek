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
#include <cstdint>

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
  int versus;
  bool has_bounds = false;
  std::map<std::string, double> benchmarks;
  std::list<Polygon> polygons;
  std::string named_sequence;
  std::vector<std::pair<int, int>> treemap;

  void draw_on_bitmap(RawBitmap& canvas) const;

  void print_polygons() {
    int counter = 0;
    for (const auto& polygon : polygons) {
      std::cout << counter << " - " << "outer" << "\n";
      for (const Point& p : polygon.outer) std::cout << p.toString();
      bool first = true;
      for (const auto& seq : polygon.inner) {
        if (!first) std::cout << "\n";
        first = false;
        for (const Point& p : seq) std::cout << p.toString();
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
      for (Point& p : polygon.outer) p.x += x;
      for (auto& seq : polygon.inner) {
        for (Point& p : seq) p.x += x;
      }
      polygon.bounds.min_x += x;
      polygon.bounds.max_x += x;
    }
  }

  void to_svg_stream(std::ostream& os) const {
    os << "<svg xmlns=\"http://www.w3.org/2000/svg\" "
       << "width=\"" << width << "\" height=\"" << height << "\">\n";
    for (const auto& poly : polygons) {
      // --- OUTER (Red) ---
      if (!poly.outer.empty()) {
        os << "<polygon points=\"";
        bool first = true;
        for (const Point& p : poly.outer) {
          if (!first) os << " ";
          first = false;
          os << p.x << "," << p.y;
        }
        os << "\" fill=\"none\" stroke=\"red\" stroke-width=\"1\"/>\n";
      }
      // --- INNER (Green) ---
      for (const auto& sequence : poly.inner) {
        if (sequence.empty()) continue;
        os << "<polygon points=\"";
        bool first = true;
        for (const Point& p : sequence) {
          if (!first) os << " ";
          first = false;
          os << p.x << "," << p.y;
        }
        os << "\" fill=\"none\" stroke=\"green\" stroke-width=\"1\"/>\n";
      }
    }
    os << "</svg>";
  }

  void save_svg(const std::string& filename) const {
    std::ofstream file(filename);
    if (!file.is_open()) {
      throw std::runtime_error("Unable to open SVG file: " + filename);
    }
    to_svg_stream(file);
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

      int x = this->start_x;

      if (bpp == 4) {
        for (; x <= this->end_x - 4; x += 4) {
          // read 4 pixels (16 bytes)
          unsigned int c0 = fetch_color(p);
          unsigned int c1 = fetch_color(p + 4);
          unsigned int c2 = fetch_color(p + 8);
          unsigned int c3 = fetch_color(p + 12);

          // extracts value (used as debugging segment label)
          unsigned char v0 = static_cast<unsigned char>(c0);
          unsigned char v1 = static_cast<unsigned char>(c1);
          unsigned char v2 = static_cast<unsigned char>(c2);
          unsigned char v3 = static_cast<unsigned char>(c3);

          p += 16;

          bool m0 = specific_matcher->match(c0);
          bool m1 = specific_matcher->match(c1);
          bool m2 = specific_matcher->match(c2);
          bool m3 = specific_matcher->match(c3);

          if (m0) {
            if (!matching) {
              min_x = x; last_red_value = v0; matching = true;
            }
          } else if (matching) {
            this->node_cluster->add_node(min_x, x - 1, y, last_red_value, offset);
            matching = false;
          }

          if (m1) {
            if (!matching) {
              min_x = x + 1; last_red_value = v1; matching = true;
            }
          } else if (matching) {
            this->node_cluster->add_node(min_x, x, y, last_red_value, offset);
            matching = false;
          }

          if (m2) {
            if (!matching) {
              min_x = x + 2; last_red_value = v2; matching = true;
            }
          } else if (matching) {
            this->node_cluster->add_node(min_x, x + 1, y, last_red_value, offset);
            matching = false;
          }

          if (m3) {
            if (!matching) {
              min_x = x + 3; last_red_value = v3; matching = true;
            }
          } else if (matching) {
            this->node_cluster->add_node(min_x, x + 2, y, last_red_value, offset);
            matching = false;
          }
        }
      }

      // remaining pixels (width not a multiple of 4)
      for (; x < this->end_x; x++) {
        unsigned int color = fetch_color(p);
        unsigned char current_val = static_cast<unsigned char>(color);
        p += bpp;
        if (specific_matcher->match(color)) {
          if (!matching) {
            min_x = x;
            last_red_value = current_val;
            matching = true;
          }
        } else if (matching) {
          this->node_cluster->add_node(min_x, x - 1, y, last_red_value, offset);
          matching = false;
        }
      }

      if (matching) {
        this->node_cluster->add_node(min_x, this->end_x - 1, y, last_red_value, offset);
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
