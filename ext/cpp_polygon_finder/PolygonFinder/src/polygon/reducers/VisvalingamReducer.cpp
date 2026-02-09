/*
 * VisvalingamReducer.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <vector>
#include "VisvalingamReducer.h"

VisvalingamReducer::VisvalingamReducer(std::vector<Point*>& list_of_points, float tolerance)
  : Reducer(list_of_points) {
  this->tolerance = tolerance * tolerance;
}

VisvalingamReducer::~VisvalingamReducer() {}

void VisvalingamReducer::reduce() {
  std::vector<Point*> new_points = this->simplify();
  points.assign(new_points.begin(), new_points.end());
}

std::vector<Point*> VisvalingamReducer::simplify() {
  Vertex* vwLine = Vertex::buildLine(points);
  float minArea = this->tolerance;
  for (;;) {
      minArea = simplifyVertex(vwLine);
      if (minArea >= this->tolerance) break;
  }
  return Vertex::getCoordinates(vwLine);
}

float VisvalingamReducer::simplifyVertex(Vertex* vwLine) {
  Vertex* curr = vwLine;
  float minArea = curr->getArea();
  Vertex* minVertex = nullptr;
  while (curr) {
      float area = curr->getArea();
      if (area < minArea) {
          minArea = area;
          minVertex = curr;
      }
      curr = curr->get_next();
  }
  if (minVertex && minArea < this->tolerance) minVertex->remove();
  if (!vwLine->isLiving()) return -1;
  return minArea;
}
