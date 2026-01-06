/*
 * Sequence.cpp
 *
 *  Created on: 23 nov 2025
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include <string>
#include "Sequence.h"

std::string Sequence::toString() {
  std::string retme = "";
  this->each([&](QNode<Point>* pos) -> bool {
    retme += pos->payload->toString();
    return true;
  });
  return(retme);
}

bool Sequence::is_not_vertical()
{ if (this->size < 2) {
    return false;
  }
  int x0 = head->payload->x;
  this->rewind();

  while (QNode<Point>* position = this->iterator())
  { if (position->payload->x != x0) {
      return true;
    }
    this->forward();
  }
  return false;
}
