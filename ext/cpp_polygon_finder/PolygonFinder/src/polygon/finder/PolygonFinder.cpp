/*
 * PolygonFinder.cpp
 *
 *  Created on: 24 nov 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include <iostream>
#include <list>
#include <map>
#include <ctime>
#include <typeinfo>
#include <string>
#include <vector>
#include <utility>
#include "PolygonFinder.h"
#include "../bitmaps/Bitmap.h"
#include "../matchers/Matcher.h"
#include "../matchers/RGBMatcher.h"
#include "../matchers/RGBNotMatcher.h"
#include "optionparser.h"
#include "NodeCluster.h"
#include "Node.h"
#include "FinderUtils.h"

PolygonFinder::PolygonFinder(Bitmap *bitmap,
                             Matcher *matcher,
                             Bitmap *test_bitmap,
                             std::vector<std::string> *options,
                             int start_x,
                             int end_x)
    : source_bitmap(bitmap),
      matcher(matcher),
      start_x(start_x),
      end_x(end_x == -1 ? bitmap->w() : end_x)
{ this->rgb_matcher = dynamic_cast<RGBMatcher*>(matcher);
  if (options != nullptr) FinderUtils::sanitize_options(this->options, options);
  this->node_cluster = new NodeCluster(source_bitmap->h(), source_bitmap->w(), &this->options);

  //= SCAN ==============//
  cpu_timer.start();
  scan();
  reports["scan"] = cpu_timer.stop();
  //=====================//

  //= BUILD_TANGS_SEQUENCE ===//
  cpu_timer.start();
  node_cluster->build_tangs_sequence();
  reports["build_tangs_sequence"] = cpu_timer.stop();
  //=====================//

  //= PLOT ===//
  cpu_timer.start();
  node_cluster->plot(this->options.versus);
  reports["plot"] = cpu_timer.stop();
  //=====================//

  //= COMPRESS_COORDS ===//
  cpu_timer.start();
  node_cluster->compress_coords(this->node_cluster->polygons, this->options);
  reports["compress"] = cpu_timer.stop();
  //=====================//
  reports["total"] = reports["scan"] + reports["build_tangs_sequence"] + reports["plot"] + reports["compress"];
}

std::list<ShapeLine*> *PolygonFinder::get_shapelines() {
  std::list<ShapeLine*> *sll = new std::list<ShapeLine*>();
  for (int line = 0; line < this->node_cluster->height; line++) {
    for (Node& node : this->node_cluster->vert_nodes[line]) {
      ShapeLine *sl = new ShapeLine({node.min_x, node.max_x, node.y});
      sll->push_back(sl);
    }
  }
  return sll;
}

PolygonFinder::~PolygonFinder() {
  delete this->node_cluster;
}

void PolygonFinder::scan() {
    int bpp = this->source_bitmap->get_bytes_per_pixel();

    RGBMatcher* rgb_m = dynamic_cast<RGBMatcher*>(this->matcher);

    if (bpp == 1) {
      auto fetcher = [](const unsigned char* p) { return static_cast<unsigned int>(p[0]); };
      if (rgb_m) run_loop(rgb_m, fetcher);
      else       run_loop(this->matcher, fetcher);
    } else {
      auto fetcher = [](const unsigned char* p) { return *reinterpret_cast<const uint32_t*>(p); };
      if (rgb_m) run_loop(rgb_m, fetcher);
      else       run_loop(this->matcher, fetcher);
    }
}

ProcessResult* PolygonFinder::process_info() {
  ProcessResult *pr = new ProcessResult();
  pr->groups = this->node_cluster->sequences.size();
  pr->polygons = std::move(this->node_cluster->polygons);
  pr->benchmarks = std::move(this->reports);
  pr->treemap = this->node_cluster->treemap;

  if (this->node_cluster->options->named_sequences && typeid(*this->source_bitmap) == typeid(Bitmap))
  { std::string sequence;
    int n = 0;
    for (const auto& seq_list : this->node_cluster->sequences) {
      std::string seq;
      for (Node* node : seq_list) {
        seq += node->name;
      }
      if (n != 0) sequence += '-';
      sequence += seq;
      n++;
    }
    pr->named_sequence = sequence;
  }
  else pr->named_sequence = "";
  return(pr);
}
