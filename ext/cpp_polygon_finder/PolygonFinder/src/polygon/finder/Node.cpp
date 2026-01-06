/*
 * Node.cpp
 *
 *  Created on: 26 nov 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include <string.h>
#include <string>
#include <iostream>
#include <algorithm>
#include <vector>
#include <list>
#include "Node.h"

Node::Node(int min_x, int max_x, int y, char name) {
  this->name = name;
  this->min_x = min_x;
  this->max_x = max_x;
  this->y = y;
  this->tangs_count = 0;
  this->abs_x_index = 0;
  this->down_indexer = 0;
  this->up_indexer = 0;
  this->track = 0;
  this->outer_index = -1;
  this->inner_index = -1;
}

bool Node::get_trackmax() {
  return((this->track & OMAX) != 0);
}
bool Node::track_complete() {
  return((this->track & OCOMPLETE) == OCOMPLETE);
}
bool Node::track_uncomplete() {
  return((this->track & OCOMPLETE) != OCOMPLETE);
}

bool Node::tangs_with(Node *node) {
  return(this->min_x <= node->max_x && node->min_x <= this->max_x);
}

void Node::add_intersection(Node *other_node) {
  if (other_node->y < this->y) tangs[T_UP].push_back(other_node);
  else                         tangs[T_DOWN].push_back(other_node);
}

void Node::precalc_tangs_sequences(std::vector<Point>& points) {
  this->tangs_sequence.clear();
  this->tangs_sequence.reserve(tangs[T_UP].size() + tangs[T_DOWN].size());
  std::vector<Node*> up_copy = tangs[T_UP];
  std::vector<Node*> down_copy = tangs[T_DOWN];

  // --- CLOCKWISE (UP) ---
  std::sort(up_copy.begin(), up_copy.end(), sort_min_x);
  if (!up_copy.empty()) {
    this->up_indexer = -up_copy.front()->abs_x_index;
  }
  for (Node* t_node : up_copy) {
    tangs_sequence.push_back(NodeDescriptor{
      t_node,
      Tangent{ &points.emplace_back(t_node->max_x, t_node->y), OMAX},
      Tangent{ &points.emplace_back(t_node->min_x, t_node->y), OMIN}
    });
  }

  // --- COUNTER-CLOCKWISE (DOWN) ---
  std::sort(down_copy.begin(), down_copy.end(), sort_max_x);
  std::reverse(down_copy.begin(), down_copy.end());
  if (!down_copy.empty()) {
    this->down_indexer = (down_copy.back()->abs_x_index +
                         tangs[T_UP].size() + tangs[T_DOWN].size() - 1);
  }
  for (Node* t_node : down_copy) {
    tangs_sequence.push_back(NodeDescriptor{
      t_node,
      Tangent{&points.emplace_back(t_node->min_x, t_node->y), OMIN},
      Tangent{&points.emplace_back(t_node->max_x, t_node->y), OMAX}
    });
  }
  this->tangs_count = this->tangs_sequence.size();
}

bool Node::sort_min_x(Node *a, Node *b) {
  return(a->min_x <= b->min_x);
}
bool Node::sort_max_x(Node *a, Node *b) {
  return(a->max_x <= b->max_x);
}
Node* Node::my_next_inner(Node *last, int versus) {
  unsigned int last_node_index;
  if (last->y < this->y)       last_node_index = last->abs_x_index + this->up_indexer;
  else            last_node_index = this->down_indexer - last->abs_x_index;
  if (versus == Node::O) last_node_index == 0 ? last_node_index = this->tangs_sequence.size() - 1 : last_node_index--;
  else          last_node_index == this->tangs_sequence.size() - 1 ? last_node_index = 0 : last_node_index++;
  return((this->tangs_sequence)[last_node_index].node);
}
Node* Node::my_next_outer(Node *last, int versus) {
  unsigned int last_node_index;
  if (last->y < this->y) last_node_index = last->abs_x_index + this->up_indexer;
  else                   last_node_index = this->down_indexer - last->abs_x_index;
  if (versus == Node::O) last_node_index == this->tangs_sequence.size() - 1 ? last_node_index = 0 : last_node_index++;
  else                   last_node_index == 0 ? last_node_index = this->tangs_sequence.size() - 1 : last_node_index--;
  return((this->tangs_sequence)[last_node_index].node);
}

Point* Node::coords_entering_to(Node *enter_to, int mode, int tracking) {
  int enter_to_index;
  if (enter_to->y < this->y) enter_to_index = enter_to->abs_x_index + this->up_indexer;
  else                       enter_to_index = this->down_indexer - enter_to->abs_x_index;
  NodeDescriptor ds = (this->tangs_sequence)[enter_to_index];
  Tangent t = (mode == Node::O ? ds.o : ds.a);
  enter_to->track |= TURNER[tracking][t.mode - 1];
  return(t.point);
}
