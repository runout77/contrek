/*
 * Position.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
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
