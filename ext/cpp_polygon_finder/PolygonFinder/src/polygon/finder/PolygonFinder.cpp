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
#include <ctime>
#include <vector>
#include "PolygonFinder.h"
#include "../bitmaps/Bitmap.h"
#include "../matchers/Matcher.h"
#include "../matchers/RGBMatcher.h"
#include "optionparser.h"
#include "NodeCluster.h"
#include "Node.h"

PolygonFinder::PolygonFinder(Bitmap *bitmap, Matcher *matcher, Bitmap *test_bitmap, std::vector<std::string> *options) {
  source_bitmap = bitmap;
  this->matcher = matcher;
  if (options != nullptr) sanitize_options(options);
  this->node_cluster = new NodeCluster(source_bitmap->h(), &this->options);

  //= SCAN ==============//
  start_timer();
  scan();
  reports["scan"] = end_timer();
  //=====================//

  //= BUILD_TANGS_SEQUENCE ===//
  start_timer();
  node_cluster->build_tangs_sequence();
  reports["build_tangs_sequence"] = end_timer();
  //=====================//

  //= PLOT ===//
  start_timer();
  node_cluster->plot(this->options.versus);
  reports["plot"] = end_timer();
  //=====================//

  //= COMPRESS_COORDS ===//
  start_timer();
  node_cluster->compress_coords(this->options);
  reports["compress"] = end_timer();
  //=====================//
  reports["total"] = reports["scan"] + reports["build_tangs_sequence"] + reports["plot"] + reports["compress"];
}

std::list<ShapeLine*> *PolygonFinder::get_shapelines() {
  std::list<ShapeLine*> *sll = new std::list<ShapeLine*>();
  for (int line = 0; line < this->node_cluster->height; line++)
  { for (std::vector<Node*>::iterator node = this->node_cluster->vert_nodes[line].begin(); node != this->node_cluster->vert_nodes[line].end(); ++node)
    { ShapeLine *sl = new ShapeLine({(*node)->min_x, (*node)->max_x, (*node)->y});
      sll->push_back(sl);
    }
  }
  return(sll);
}

void PolygonFinder::sanitize_options(std::vector<std::string> *incoming_options)
{ std::vector<char*> argv0;
  for (const auto& arg : *incoming_options)
  argv0.push_back((char*)arg.data());
  argv0.push_back(nullptr);
  char** argv = &argv0[0];
  int argc = argv0.size() -1;

  enum  optionIndex { COMPRESS_UNIQ, VERSUS, COMPRESS_VISVALINGAM, COMPRESS_LINEAR, COMPRESS_VISVALINGAM_TOLERANCE, TREEMAP};
  const option::Descriptor usage[] = {
     //  {UNKNOWN, 0,"" , ""    ,option::Arg::None, 0},
     {COMPRESS_VISVALINGAM, 0, "" , "compress_visvalingam", option::Arg::None, 0},
     {COMPRESS_LINEAR, 0, "" , "compress_linear", option::Arg::None, 0},
     {COMPRESS_VISVALINGAM_TOLERANCE, 0, "" , "compress_visvalingam_tolerance", option::Arg::Optional, 0},
     {COMPRESS_UNIQ, 0, "", "compress_uniq", option::Arg::None, 0},
     {TREEMAP, 0, "", "treemap", option::Arg::None, 0},
     {VERSUS, 0, "v", "versus", option::Arg::Optional, 0},
     {0, 0, 0, 0, 0, 0}
  };

  option::Stats  stats(usage, argc, argv);
  option::Option ioptions[stats.options_max], buffer[stats.buffer_max];
  option::Parser parse(usage, argc, argv, ioptions, buffer);

  if (parse.error())  return;
  // VERSUS
  if (ioptions[VERSUS].count() > 0)
  { for (option::Option* opt = ioptions[VERSUS]; opt; opt = opt->next())
    { std::string opts = opt->arg;
      this->options.versus = (opts.compare("a") == 0 ? Node::A : Node::O);
      break;
    }
  }
  // COMPRESS UNIQ
  if (ioptions[COMPRESS_UNIQ].count() > 0)
  { this->options.compress_uniq = true;
  }
  // TREEMAP
  if (ioptions[TREEMAP].count() > 0)
  { this->options.treemap = true;
  }
  // COMPRESS LINEAR
  if (ioptions[COMPRESS_LINEAR].count() > 0)
  { this->options.compress_linear = true;
  }
  // COMPRESS UNIQ
  if (ioptions[COMPRESS_VISVALINGAM].count() > 0)
  { this->options.compress_visvalingam = true;
  }
  if (ioptions[COMPRESS_VISVALINGAM_TOLERANCE].count() > 0)
  { this->options.compress_visvalingam = true;
    for (option::Option* opt = ioptions[COMPRESS_VISVALINGAM_TOLERANCE]; opt; opt = opt->next())
    { std::string opts = opt->arg;
      this->options.compress_visvalingam_tolerance = strtof(opt->arg, 0);
      break;
    }
  }
  /*std::cout << "-----------" << std::endl;
  std::cout << "versus" << this->options.versus << std::endl;
  std::cout << "uniq" << this->options.compress_uniq << std::endl;
  std::cout << "linear" << this->options.compress_linear << std::endl;
  std::cout << "visvalingam" << this->options.compress_visvalingam << std::endl;
  std::cout << this->options.compress_visvalingam_tolerance << std::endl;
  std::cout << "-----------" << std::endl;*/
}

void PolygonFinder::start_timer() {
  timer_start = std::clock();
}

double PolygonFinder::end_timer() {
  std::clock_t c_end = std::clock();
  return 1000.0 * (c_end - timer_start) / CLOCKS_PER_SEC;
}

PolygonFinder::~PolygonFinder() {
}

void PolygonFinder::scan() {
  char last_color = 0, color = 0;
  int min_x = 0;
  int max_x = 0;
  bool match;
  bool matching = false;

  for (int y = 0; y < this->source_bitmap->h(); y++)
  { for (int x = 0; x < this->source_bitmap->w(); x++)
    { color = this->source_bitmap->value_at(x, y);
      match = this->source_bitmap->pixel_match(x, y, this->matcher);
      if (match && matching == false)
      { min_x = x;
        last_color = color;
        matching = true;
        if (x == (this->source_bitmap->w() - 1) )
        { max_x = x;
          this->node_cluster->add_node(new Node(min_x, max_x, y, last_color));
          matching = false;
        }
      } else {
        if (!match && matching == true)
        { max_x = x - 1;
          this->node_cluster->add_node(new Node(min_x, max_x, y, last_color));
          matching = false;
        } else {
                  if (x == (this->source_bitmap->w()-1) && matching == true)
                  { max_x = x;
                    this->node_cluster->add_node(new Node(min_x, max_x, y, last_color));
                    matching = false;
                  }
                }
      }
    }
  }
}

ProcessResult* PolygonFinder::process_info() {
  ProcessResult *pr = new ProcessResult();
  pr->groups = this->node_cluster->sequences->size();
  pr->polygons = this->node_cluster->polygons;
  pr->benchmarks = this->reports;
  pr->treemap = this->node_cluster->treemap;

  if (typeid(*this->source_bitmap) == typeid(Bitmap))
  { std::string sequence;
    int n = 0;
    for (std::list<std::list<Node*>*>::iterator list = this->node_cluster->sequences->begin(); list != this->node_cluster->sequences->end(); ++list, n++)
    { std::string seq;
      for (std::list<Node*>::iterator node = (*list)->begin(); node != (*list)->end(); ++node)
      { seq += (*node)->name;
      }
      if (n != 0) sequence += '-';
      sequence += seq;
    }
    pr->named_sequence = sequence;
  }
  else pr->named_sequence = "";
  return(pr);
}
