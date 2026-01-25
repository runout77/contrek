/*
 * Position.cpp
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */
#include <iostream>
#include "Position.h"
#include "Hub.h"

Position::Position(Hub* hub, Point* point)
: QNode<Point>(point)
{ int key = point->y * hub->width() + (point->x - hub->start_x());
  EndPoint* existing_ep = hub->get(key);
  if (existing_ep == nullptr)
  { end_point_ = hub->put(key, hub->spawn_end_point());
  } else {
    end_point_ = existing_ep;
  }
}

void Position::before_rem(Queueable<Point>* q)  {
  auto& queues = this->end_point_->queues();
  queues.erase(std::remove(queues.begin(), queues.end(), q), queues.end());
}

void Position::after_add(Queueable<Point>* q)  {
  this->end_point_->queues().push_back(q);
}
