/*
 * Position.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */
#include <iostream>
#include "Position.h"
#include "Hub.h"

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
  if (this->end_point_ != nullptr) this->end_point_->queues().erase(q);
}

void Position::after_add(Queueable<Point>* q)  {
  if (this->end_point_ != nullptr) this->end_point_->queues().insert(q);
}
