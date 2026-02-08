/*
 * Position.h
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include "Queueable.h"
#include "../Node.h"
#include "EndPoint.h"
#include "Hub.h"

class EndPoint;
class Hub;
class Position : public QNode<Point>{
 public:
  explicit Position(Hub* hub, Point* point);
  explicit Position(EndPoint* end_point);
  EndPoint* end_point() { return end_point_; }
  void before_rem(Queueable<Point>* q) override;
  void after_add(Queueable<Point>* q) override;
 private:
  EndPoint* end_point_ = nullptr;
};
