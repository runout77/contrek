/*
 * Node.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <string.h>
#include <string>
#include <iostream>
#include <algorithm>
#include <limits>
#include <vector>
#include <list>
#include "Node.h"
#include "NodeCluster.h"

Node::Node(int min_x, int max_x, int y, NodeCluster* cluster, char name)
: start_point(min_x, y),
  end_point(max_x, y),
  cluster(cluster) {
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

void Node::add_intersection(Node& other_node, int other_node_index) {
  if (other_node.y < this->y) {
    upper_start = std::min(upper_start, other_node_index);
    upper_end = std::max(upper_end, other_node_index);
  } else {
    lower_start = std::min(lower_start, other_node_index);
    lower_end = std::max(lower_end, other_node_index);
  }
}

void Node::precalc_tangs_sequences(NodeCluster& cluster) {
  this->tangs_sequence.clear();

  int lower_size = this->lower_end >= 0 ? (this->lower_end - this->lower_start + 1) : 0;
  int upper_size = this->upper_end >= 0 ? (this->upper_end - this->upper_start + 1) : 0;
  this->tangs_sequence.reserve(lower_size + upper_size);

  if (this->upper_end >= 0) {
    this->up_indexer = -cluster.vert_nodes[y + T_UP][this->upper_start].abs_x_index;
  }
  // --- CLOCKWISE (UP) ---
  for (int upper_pos = this->upper_start; upper_pos <= this->upper_end; upper_pos++) {
    tangs_sequence.push_back(-(upper_pos + 1));
  }
  if (this->lower_end >= 0) {
    this->down_indexer = (cluster.vert_nodes[y + T_DOWN][this->lower_start].abs_x_index + lower_size + upper_size - 1);
  }
  // --- COUNTER-CLOCKWISE (DOWN) ---
  for (int lower_pos = this->lower_end; lower_pos >= this->lower_start; lower_pos--) {
    tangs_sequence.push_back(lower_pos);
  }
  this->tangs_count = this->tangs_sequence.size();
}

Node* Node::my_next_inner(Node *last, int versus) {
  unsigned int last_node_index;
  if (last->y < this->y)       last_node_index = last->abs_x_index + this->up_indexer;
  else            last_node_index = this->down_indexer - last->abs_x_index;
  if (versus == Node::O) last_node_index == 0 ? last_node_index = this->tangs_sequence.size() - 1 : last_node_index--;
  else          last_node_index == this->tangs_sequence.size() - 1 ? last_node_index = 0 : last_node_index++;
  return get_tangent_node_by_virtual_index(this->tangs_sequence[last_node_index]);
}

Node* Node::my_next_outer(Node *last, int versus) {
  unsigned int last_node_index;
  if (last->y < this->y) last_node_index = last->abs_x_index + this->up_indexer;
  else                   last_node_index = this->down_indexer - last->abs_x_index;
  if (versus == Node::O) last_node_index == this->tangs_sequence.size() - 1 ? last_node_index = 0 : last_node_index++;
  else                   last_node_index == 0 ? last_node_index = this->tangs_sequence.size() - 1 : last_node_index--;
  return get_tangent_node_by_virtual_index(this->tangs_sequence[last_node_index]);
}

Point* Node::coords_entering_to(Node *enter_to, int mode, int tracking) {
  int enter_to_index;
  if (enter_to->y < this->y) enter_to_index = enter_to->abs_x_index + this->up_indexer;
  else                       enter_to_index = this->down_indexer - enter_to->abs_x_index;

  int tg_index = this->tangs_sequence[enter_to_index];
  Point* point;
  if (tg_index < 0) {
    Node& node_up = cluster->vert_nodes[y + T_UP][-(tg_index + 1)];
    if (mode == Node::A) {
      enter_to->track |= TURNER[tracking][OMAX - 1];
      point = &node_up.end_point;
    } else {
      enter_to->track |= TURNER[tracking][OMIN - 1];
      point = &node_up.start_point;
    }
  } else {
    Node& node_down = cluster->vert_nodes[y + T_DOWN][tg_index];
    if (mode == Node::A) {
      enter_to->track |= TURNER[tracking][OMIN - 1];
      point = &node_down.start_point;
    } else {
      enter_to->track |= TURNER[tracking][OMAX - 1];
      point = &node_down.end_point;
    }
  }
  return point;
}

Node* Node::get_tangent_node_by_virtual_index(int virtual_index) {
  if (virtual_index < 0) {
    return &(this->cluster->vert_nodes[y + T_UP][-(virtual_index + 1)]);
  } else {
    return &(this->cluster->vert_nodes[y + T_DOWN][virtual_index]);
  }
}
