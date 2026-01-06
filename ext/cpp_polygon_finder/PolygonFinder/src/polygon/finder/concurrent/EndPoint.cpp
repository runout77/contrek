/*
 * EndPoint.cpp
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include "EndPoint.h"
#include <iostream>

bool EndPoint::queues_include(Queueable<Point>* q) const {
  return (std::find(queues_.begin(), queues_.end(), q) != queues_.end());
}
