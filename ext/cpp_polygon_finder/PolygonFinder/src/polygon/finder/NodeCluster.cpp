/*
 * NodeCluster.cpp
 *
 *  Created on: 26 nov 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include "NodeCluster.h"
#include "Node.h"
#include "../reducers/UniqReducer.h"
#include "../reducers/LinearReducer.h"
#include "../reducers/VisvalingamReducer.h"
#include <iostream>
#include <list>
#include <algorithm>
#include <map>
#include <string>
#include <vector>

NodeCluster::NodeCluster(int h, pf_Options *options) {
  this->vert_nodes = new std::vector<Node*>[h];
  versus_inverter[Node::O] = Node::A;
  versus_inverter[Node::A] = Node::O;
  this->options = options;
  this->height = h;
  this->nodes = 0;
  this->plot_sequence = nullptr;
  this->sequence_coords = nullptr;
  this->sequences = new std::list<std::list<Node*>*>();

  this->root_nodes = this->lists.add_list();
  this->inner_plot = this->lists.add_list();
  this->inner_new = this->lists.add_list();
}

NodeCluster::~NodeCluster() {
}

void NodeCluster::compress_coords(pf_Options options) {
  if (options.compress_linear || options.compress_uniq || options.compress_visvalingam)
  { std::list<std::list<Point*>*> sequences;
    for (std::list<std::map<std::string, std::list<std::list<Point*>*>>>::iterator x = this->polygons.begin(); x != this->polygons.end(); ++x)
    { for (std::list<std::list<Point*>*>::iterator y = (*x)["outer"].begin(); y != (*x)["outer"].end(); ++y)
      { sequences.push_back(*y);
      }
      for (std::list<std::list<Point*>*>::iterator y = (*x)["inner"].begin(); y != (*x)["inner"].end(); ++y)
      { sequences.push_back(*y);
      }
    }
    if (options.compress_uniq)
    { for (std::list<std::list<Point*>*>::iterator it = sequences.begin(); it != sequences.end(); ++it)
      { UniqReducer reducer(*it);
        reducer.reduce();
      }
    }
    if (options.compress_linear)
    { for (std::list<std::list<Point*>*>::iterator it = sequences.begin(); it != sequences.end(); ++it)
      { LinearReducer reducer(*it);
        reducer.reduce();
      }
    }
    if (options.compress_visvalingam)
    { for (std::list<std::list<Point*>*>::iterator it = sequences.begin(); it != sequences.end(); ++it)
      { VisvalingamReducer reducer(*it, options.compress_visvalingam_tolerance);
        reducer.reduce();
      }
    }
  }
}


void NodeCluster::build_tangs_sequence() {
  for (int line = 0; line < this->height; line++)
  { for (std::vector<Node*>::iterator node = vert_nodes[line].begin(); node != vert_nodes[line].end(); ++node)
    { (*node)->precalc_tangs_sequences();
    }
  }
}

void NodeCluster::add_node(Node *node) {
  this->nodes++;
  node->data_pointer = this->lists.get_data_pointer();
  node->abs_x_index = vert_nodes[node->y].size();
  vert_nodes[node->y].push_back(node);
  root_nodes->push_back(node);

  if (node->y > 0)
  { std::vector<Node*> *up_nodes = &vert_nodes[node->y - 1];
    int up_nodes_count = up_nodes->size();
    Node *up_node;
    if (up_nodes_count > 0)
    { int index = 0;
      do
      { up_node = (*up_nodes)[index];
          if (up_node->max_x >= node->min_x)
          { if (up_node->min_x <= node->max_x)
            { node->add_intersection(up_node);
              (up_node)->add_intersection(node);
            }
          if (++index == up_nodes_count) return;
          do
          { up_node = (*up_nodes)[index];
            if (up_node->min_x <= node->max_x)
            {   node->add_intersection(up_node);
              (up_node)->add_intersection(node);
            }
            else  return;
          }while (++index != up_nodes_count);
          return;
          }
      }while(++index != up_nodes_count);
    }
  }
}

std::list<Point*>* NodeCluster::get_coords() {
  return(this->sequence_coords);
}

void NodeCluster::plot(int versus) {
  int inner_v = versus_inverter[versus];
  int index_order = 0;
  Node *next_node;

  while (root_nodes->size() > 0)
  { Node *root_node = (Node*) root_nodes->shift();
    root_node->outer_index = index_order;
    this->plot_sequence = new std::list<Node*>();
    this->sequence_coords = new std::list<Point*>();

    plot_sequence->push_back(root_node);

    if ((root_node)->tangs_sequence->size() > 0)  // front() on empty list is undefined
    { versus == Node::A ? next_node = root_node->tangs_sequence->back()->node : next_node = root_node->tangs_sequence->front()->node;
      if (next_node != nullptr)
      { sequence_coords->push_back(next_node->coords_entering_to(root_node, versus_inverter[versus], Node::OUTER));
      }
      if ((this->nodes > 0) && (next_node != nullptr))
      { plot_node(next_node, root_node, versus);
      }
      this->sequences->push_back(plot_sequence);
      std::list<std::list<Point*>*> outer_container, inner_container;
      outer_container.push_back(sequence_coords);
      std::list<Point*> pl_inner;
      std::map<std::string, std::list<std::list<Point*>*>> poly;
      poly["outer"] = outer_container;
      poly["inner"] = inner_container;
      if (sequence_coords->size() > 2) this->polygons.push_back(poly);

      int index_inner = 0;
      while (inner_plot->size() > 0)
      { this->plot_sequence = new std::list<Node*>();
        this->sequence_coords = new std::list<Point*>();
        std::list<Node*>::iterator first_i;
        Node *first = nullptr;

        Listable *act = inner_plot->first();
        do
        { if (((Node*)act)->tangs_count <= 2)
          { first = (Node*) act;
            break;
          }
        }while((act = act->data_pointer[inner_plot->get_id()].next) != nullptr);

        if (first == nullptr) first = (Node*) inner_plot->first();

        plot_sequence->push_back(first);
        inner_plot->remove(first);
        root_nodes->remove(first);

        first->inner_index = index_inner;

        Node *next_node;
        if (first->get_trackmax())
        { if (inner_v == Node::A)  next_node = first->tangs[Node::T_UP].front();
          else                     next_node = first->tangs[Node::T_DOWN].front();
        } else {
          if (inner_v == Node::A)  next_node = first->tangs[Node::T_DOWN].back();
          else                     next_node = first->tangs[Node::T_UP].back();
        }

        if (next_node != nullptr)
        { sequence_coords->push_back(next_node->coords_entering_to(first, inner_v, Node::INNER));
          plot_inner_node(next_node, inner_v, first, root_node);
        }

        this->polygons.back()["inner"].push_back(sequence_coords);
        this->inner_plot->grab(this->inner_new);
        index_inner++;
      }
    } else {
      this->sequences->push_back(plot_sequence);
    }
    // tree
    if (this->options->treemap)
    { this->treemap.push_back(versus == Node::A ? this->test_in_hole_a(root_node) : this->test_in_hole_o(root_node));
    }
    index_order++;
  }
}

int *NodeCluster::test_in_hole_a(Node *node)
{ if (node->outer_index > 0)
  { int start_left = node->abs_x_index - 1;
    do
    { Node *prev = this->vert_nodes[node->y][start_left];
      int cindex = prev->outer_index;
      if ((cindex < node->outer_index) && ((prev->track & Node::IMAX) != 0))
      { unsigned int start_right = node->abs_x_index;
        unsigned int line_size = this->vert_nodes[node->y].size();
        while (++start_right != line_size)
        { Node *tnext = this->vert_nodes[node->y][start_right];
          if (tnext->outer_index == cindex)
          { if ((tnext->track & Node::IMIN) != 0)  return(new int[2] {cindex, prev->inner_index});
            else                                   return(new int[2] {-1, -1});
          }
        }
      }
    }while(--start_left >= 0);
  }
  return(new int[2] {-1, -1});
}

int *NodeCluster::test_in_hole_o(Node *node)
{ unsigned int line_size = this->vert_nodes[node->y].size();
  if ((node->outer_index) > 0 && (vert_nodes[node->y].back() != node))
  { unsigned int start_left = node->abs_x_index + 1;
    do
    { Node *prev = this->vert_nodes[node->y][start_left];
      int cindex = prev->outer_index;
      if ((cindex < node->outer_index) && ((prev->track & Node::IMIN) != 0))
      { int start_right = node->abs_x_index;
        while (--start_right >= 0)
        { Node *tnext = this->vert_nodes[node->y][start_right];
          if (tnext->outer_index == cindex)
          { if ((tnext->track & Node::IMAX) != 0)  return(new int[2] {cindex, prev->inner_index});
            else                                   return(new int[2] {-1, -1});
          }
        }
      }
    }while(++start_left != line_size);
  }
  return(new int[2] {-1, -1});
}

void NodeCluster::plot_inner_node(Node *node, int versus, Node *stop_at, Node *start_node) {
  node->outer_index = start_node->outer_index;
  node->inner_index = stop_at->inner_index;
  root_nodes->remove(node);
  inner_plot->remove(node);

  Node *last_node = plot_sequence->back();
  Node *next_node = node->my_next_inner(last_node, versus);

  plot_sequence->push_back(node);

  bool plot = true;
  if (next_node -> y == last_node -> y)
  { Node *n = (versus == Node::A ? node->tangs_sequence->front()->node : node->tangs_sequence->back()->node);
    plot = (n == next_node);
  }
  if (plot)
  { sequence_coords->push_back(last_node->coords_entering_to(node, versus_inverter[versus], Node::INNER));
    if (node != start_node)
    { if (last_node->y == next_node->y)
      { sequence_coords->push_back(next_node->coords_entering_to(node, versus, Node::INNER));
      }
    }
  }
  if (node->track_uncomplete())
  { this->inner_new->push_back(node);
  } else {
    inner_new->remove(node);
  }
  if (next_node == stop_at) return;
  plot_inner_node(next_node, versus, stop_at, start_node);
}

void NodeCluster::plot_node(Node *node, Node *start_node, int versus) {
  root_nodes->remove(node);
  node->outer_index = start_node->outer_index;
  Node *last_node = plot_sequence->back();
  Node *next_node = node->my_next_outer(last_node, versus);

  plot_sequence->push_back(node);
  bool plot = true;
  if (next_node -> y == last_node -> y)
  { Node *n = (versus == Node::A ? node->tangs_sequence->back()->node : node->tangs_sequence->front()->node);
    plot = (n == next_node);
  }

  if (plot)
  { sequence_coords->push_back(last_node->coords_entering_to(node, versus, Node::OUTER));
    if (node != start_node)
    { inner_plot->contains(node) ? inner_plot->remove(node) : inner_plot->push_back(node);
      if (last_node->y == next_node->y)
      { sequence_coords->push_back(next_node->coords_entering_to(node, versus_inverter[versus], Node::OUTER));
        inner_plot->contains(node) ? inner_plot->remove(node) : inner_plot->push_back(node);
      }
    }
  }
  if (node == start_node)
  { if (node->track_complete()) return;
  }
  plot_node(next_node, start_node, versus);
}

void NodeCluster::list_track(Node *node, std::list<Node*> *list) {
  std::list<Node*>::iterator i = std::find(list->begin(), list->end(), node);
  if (i == list->end())  list->push_back(node);
  else                   list_delete(node, list);
}

void NodeCluster::list_delete(Node *node, std::list<Node*> *list) {
  std::list<Node*>::iterator i;
  while ((i = std::find(list->begin(), list->end(), node)) !=  list->end())
  {  list->erase(i);
  }
}

bool NodeCluster::list_present(Node *node, std::list<Node*> *list) {
  std::list<Node*>::iterator i = std::find(list->begin(), list->end(), node);
  return(!(i == list->end()));
}
