/*
 * Position.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */
#include <iostream>
#include <algorithm>
#include "Position.h"
#include "Hub.h"
#include "Part.h"
#include "Polyline.h"

Position::Position(Hub* hub, Point* point)
: QNode<Point>(point)
{ if (hub != nullptr) {
    int key = point->y;
    EndPoint* existing_ep = hub->get(key);
    if (existing_ep == nullptr)
    { end_point_ = hub->put(key, hub->spawn_end_point());
      end_point_->set_point(point);
    } else {
      end_point_ = existing_ep;
    }
  }
}

Position::Position(EndPoint* end_point)
  : QNode<Point>(end_point->get_point())
{  this->end_point_ = end_point;
}

void Position::before_rem(Queueable<Point>* q)  {
  /*if (this->end_point_ != nullptr)
  { if (q->listable())
    { auto& v = this->end_point_->queues();
      v.erase(std::remove(v.begin(), v.end(), q), v.end());
    }
  }*/
}

void Position::after_add(Queueable<Point>* q) {
  if (this->end_point_ != nullptr && q->listable()) {
    auto& q_vec = this->end_point_->queues();
    auto it = std::find(q_vec.begin(), q_vec.end(), q);
    if (it == q_vec.end()) {
      q_vec.push_back(q);
      if (q_vec.size() > 1) {
        static_cast<Part*>(q)->polyline()->any_ancients = true;
        Queueable<Point>* first_q = q_vec.front();
        static_cast<Part*>(first_q)->polyline()->any_ancients = true;
      }
    }
  }
}
