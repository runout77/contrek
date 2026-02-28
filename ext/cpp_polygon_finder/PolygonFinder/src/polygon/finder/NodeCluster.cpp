/*
 * NodeCluster.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <iostream>
#include <list>
#include <algorithm>
#include <map>
#include <string>
#include <vector>
#include <utility>
#include <deque>
#include "NodeCluster.h"
#include "Node.h"
#include "RectBounds.h"
#include "../reducers/UniqReducer.h"
#include "../reducers/LinearReducer.h"
#include "../reducers/VisvalingamReducer.h"

NodeCluster::NodeCluster(int h, int w, pf_Options *options) {
  versus_inverter[Node::O] = Node::A;
  versus_inverter[Node::A] = Node::O;
  this->options = options;
  this->height = h;
  this->width = w;
  this->nodes = 0;

  this->vert_nodes.resize(h);
  this->root_nodes = this->lists.add_list();
  this->inner_plot = this->lists.add_list();
  this->inner_new = this->lists.add_list();
}

NodeCluster::~NodeCluster() {
}

void NodeCluster::compress_coords(std::list<Polygon>& polygons, pf_Options options) {
  if (!(options.compress_linear || options.compress_uniq || options.compress_visvalingam)) return;

  auto compress_sequence = [&](std::vector<Point*>& points_vec) {
    if (points_vec.empty()) return;

    if (options.compress_uniq) {
      UniqReducer uniq_reducer(points_vec);
      uniq_reducer.reduce();
    }
    if (options.compress_linear) {
      LinearReducer linear_reducer(points_vec);
      linear_reducer.reduce();
    }
    if (options.compress_visvalingam) {
      VisvalingamReducer vis_reducer(points_vec, options.compress_visvalingam_tolerance);
      vis_reducer.reduce();
    }
  };
  for (auto &poly : polygons) {
    compress_sequence(poly.outer);
    for (auto &inner_seq : poly.inner) {
        compress_sequence(inner_seq);
    }
  }
}

void NodeCluster::build_tangs_sequence() {
  for (auto& line : vert_nodes) {
    for (Node& node : line) {
      node.precalc_tangs_sequences(*this);
    }
  }
}

Node* NodeCluster::add_node(int min_x, int max_x, int y, char name, int offset) {
  vert_nodes[y].emplace_back(min_x, max_x, y, this, name);

  Node& node = vert_nodes[y].back();
  node.abs_x_index = vert_nodes[y].size() - 1;
  this->nodes++;

  root_nodes->push_back(&node);

  if (y > 0) {
    std::deque<Node>& up_nodes = vert_nodes[y - 1];
    if (!up_nodes.empty()) {
      auto it = std::lower_bound(up_nodes.begin(), up_nodes.end(), node.min_x,
        [&](const Node& a, int val) {
          return ((a.max_x + offset) < val);
        });

      while (it != up_nodes.end()) {
        if ((it->min_x - offset) > node.max_x) break;
        int current_index = std::distance(up_nodes.begin(), it);
        node.add_intersection(*it, current_index);
        it->add_intersection(node, node.abs_x_index);
        ++it;
      }
    }
  }
  return &node;
}

void NodeCluster::plot(int versus) {
  int inner_v = versus_inverter[versus];
  int index_order = 0;
  Node *next_node;

  while (root_nodes->size() > 0)
  { Node *root_node = reinterpret_cast<Node*>(root_nodes->shift());
    root_node->outer_index = index_order;
    this->plot_sequence.clear();
    this->plot_sequence.push_back(root_node);
    Polygon poly;

    if ((root_node)->tangs_sequence.size() > 0)  // front() or back() on empty list is undefined
    { versus == Node::A ?
        next_node = root_node->get_tangent_node_by_virtual_index(root_node->tangs_sequence.back()) :
        next_node = root_node->get_tangent_node_by_virtual_index(root_node->tangs_sequence.front());

      if (next_node != nullptr)
      { Point* p = next_node->coords_entering_to(root_node, versus_inverter[versus], Node::OUTER);
        poly.outer.push_back(p);
        poly.bounds.expand(p->x, p->y);
      }
      if ((this->nodes > 0) && (next_node != nullptr))
      { plot_node(poly.outer, next_node, root_node, versus, poly.bounds);
      }
      this->sequences.push_back(std::move(this->plot_sequence));
      this->plot_sequence.clear();

      if (poly.outer.size() > 2)
      { this->polygons.push_back(poly);
      }

      int index_inner = 0;
      while (inner_plot->size() > 0)
      { this->plot_sequence.clear();
        std::vector<Point*> inner_sequence;
        std::list<Node*>::iterator first_i;
        Node *first = nullptr;

        Listable *act = inner_plot->first();
        do
        { if ((reinterpret_cast<Node*>(act))->tangs_count <= 2)
          { first = reinterpret_cast<Node*>(act);
            break;
          }
        }while((act = act->data_pointer[inner_plot->get_id()].next) != nullptr);

        if (first == nullptr) first = reinterpret_cast<Node*>(inner_plot->first());

        plot_sequence.push_back(first);
        inner_plot->remove(first);
        root_nodes->remove(first);

        first->inner_index = index_inner;

        Node* next_node = nullptr;

        if (first->get_trackmax()) {
          if (inner_v == Node::A) {
            if (first->upper_end >= 0) next_node = &this->vert_nodes[first->y + Node::T_UP][first->upper_start];
          } else {
            if (first->lower_end >= 0) next_node = &this->vert_nodes[first->y + Node::T_DOWN][first->lower_start];
          }
        } else {
          if (inner_v == Node::A) {
            if (first->lower_end >= 0) next_node = &this->vert_nodes[first->y + Node::T_DOWN][first->lower_end];
          } else {
            if (first->upper_end >= 0) next_node = &this->vert_nodes[first->y + Node::T_UP][first->upper_end];
          }
        }

        if (next_node != nullptr)
        { inner_sequence.push_back(next_node->coords_entering_to(first, inner_v, Node::INNER));
          plot_inner_node(inner_sequence, next_node, inner_v, first, root_node);
        }
        this->polygons.back().inner.push_back(inner_sequence);
        this->inner_plot->grab(this->inner_new);
        index_inner++;
      }
    } else {
      this->sequences.push_back(std::move(this->plot_sequence));
      this->plot_sequence.clear();
    }
    // tree
    if (this->options->treemap)
    { this->treemap.push_back(versus == Node::A ? this->test_in_hole_a(root_node) : this->test_in_hole_o(root_node));
    }
    index_order++;
  }
}

std::pair<int, int> NodeCluster::test_in_hole_a(Node* node)
{ if (node->outer_index > 0)
  { int start_left = node->abs_x_index - 1;
    do {
      Node* prev = &this->vert_nodes[node->y][start_left];
      int cindex = prev->outer_index;

      if ((cindex < node->outer_index) && (prev->track & Node::IMAX))
      { unsigned int start_right = node->abs_x_index;
        unsigned int line_size = this->vert_nodes[node->y].size();
        while (++start_right != line_size)
        { Node* tnext = &this->vert_nodes[node->y][start_right];
          if (tnext->outer_index == cindex) {
            if (tnext->track & Node::IMIN) return {cindex, prev->inner_index};
            else                           return {-1, -1};
          }
        }
      }
    } while (--start_left >= 0);
  }
  return {-1, -1};
}

std::pair<int, int> NodeCluster::test_in_hole_o(Node* node)
{ auto& line = this->vert_nodes[node->y];
  const unsigned int line_size = line.size();
  if (node->outer_index == 0 || &line.back() == node) return {-1, -1};

  unsigned int start_left = node->abs_x_index + 1;
  do {
    Node* prev = &line[start_left];
    int cindex = prev->outer_index;

    if (cindex < node->outer_index && (prev->track & Node::IMIN))
    { int start_right = node->abs_x_index;
      while (--start_right >= 0) {
        Node* tnext = &line[start_right];
        if (tnext->outer_index == cindex) {
          if (tnext->track & Node::IMAX) return {cindex, prev->inner_index};
          else                           return {-1, -1};
        }
      }
    }
  } while (++start_left != line_size);
  return {-1, -1};
}

void NodeCluster::plot_inner_node(std::vector<Point*>& sequence_coords, Node *node, int versus, Node *stop_at, Node *start_node) {
  Node *current_node = node;

  while (current_node != nullptr) {
    current_node->outer_index = start_node->outer_index;
    current_node->inner_index = stop_at->inner_index;
    root_nodes->remove(current_node);
    inner_plot->remove(current_node);

    Node *last_node = plot_sequence.back();
    Node *next_node = current_node->my_next_inner(last_node, versus);

    plot_sequence.push_back(current_node);

    bool plot = true;
    if (next_node->y == last_node->y) {
      Node *n;
      int virtual_index = (versus == Node::A ?
        current_node->tangs_sequence.front() :
        current_node->tangs_sequence.back());
      n = current_node->get_tangent_node_by_virtual_index(virtual_index);
      plot = (n == next_node);
    }
    if (plot) {
      sequence_coords.push_back(last_node->coords_entering_to(current_node, versus_inverter[versus], Node::INNER));
      if (current_node != start_node) {
        if (last_node->y == next_node->y) {
          sequence_coords.push_back(next_node->coords_entering_to(current_node, versus, Node::INNER));
        }
      }
    }
    if (current_node->track_uncomplete()) {
      this->inner_new->push_back(current_node);
    } else {
      inner_new->remove(current_node);
    }
    if (next_node == stop_at) break;
    current_node = next_node;
  }
}

void NodeCluster::plot_node(std::vector<Point*>& sequence_coords, Node *node, Node *start_node, int versus, RectBounds& bounds) {
  Node *current_node = node;

  while (current_node != nullptr) {
    root_nodes->remove(current_node);
    current_node->outer_index = start_node->outer_index;

    Node *last_node = plot_sequence.back();
    Node *next_node = current_node->my_next_outer(last_node, versus);

    plot_sequence.push_back(current_node);

    bool plot = true;
    if (next_node->y == last_node->y) {
      int virtual_index = (versus == Node::A ?
          current_node->tangs_sequence.back() :
          current_node->tangs_sequence.front());
      Node *n = current_node->get_tangent_node_by_virtual_index(virtual_index);
      plot = (n == next_node);
    }
    if (plot) {
      Point* p = last_node->coords_entering_to(current_node, versus, Node::OUTER);
      sequence_coords.push_back(p);
      bounds.expand(p->x, p->y);
      if (current_node != start_node) {
        inner_plot->contains(current_node) ? inner_plot->remove(current_node) : inner_plot->push_back(current_node);
        if (last_node->y == next_node->y) {
          Point* p1 = next_node->coords_entering_to(current_node, versus_inverter[versus], Node::OUTER);
          sequence_coords.push_back(p1);
          bounds.expand(p1->x, p1->y);
          inner_plot->contains(current_node) ? inner_plot->remove(current_node) : inner_plot->push_back(current_node);
        }
      }
    }
    if (current_node == start_node) {
      if (current_node->track_complete()) break;
    }
    current_node = next_node;
  }
}
