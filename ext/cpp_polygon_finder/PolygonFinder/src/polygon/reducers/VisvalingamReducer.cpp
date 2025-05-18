/*
 * VisvalingamReducer.cpp
 *
 *  Created on: 20 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#include <iostream>
#include <list>
#include "VisvalingamReducer.h"
#include "Reducer.h"

VisvalingamReducer::VisvalingamReducer(std::list<Point*> *list_of_points, float tolerance) : Reducer(list_of_points) {
  this->tolerance = tolerance * tolerance;
}

VisvalingamReducer::~VisvalingamReducer() {
}

void VisvalingamReducer::reduce() {
  std::list<Point*> *new_points = this->simplify();
  this->points->assign(new_points->begin(), new_points->end());
}
std::list<Point*> *VisvalingamReducer::simplify() {
  Vertex *vwLine = VisvalingamReducer::Vertex::buildLine(this->points);
  float minArea = this->tolerance;
  for (;;) {
    minArea = this->simplifyVertex(vwLine);
    if (minArea >= this->tolerance) break;
  }
  std::list<Point*> *simp = vwLine->getCoordinates();
  return(simp);
}
float VisvalingamReducer::simplifyVertex(VisvalingamReducer::Vertex *vwLine) {
  VisvalingamReducer::Vertex *curr = vwLine;
  float minArea = curr->getArea();
  VisvalingamReducer::Vertex *minVertex = nullptr;
  while (curr != nullptr) {
    float area = curr->getArea();
    if (area < minArea) {
      minArea = area;
      minVertex = curr;
    }
    curr = curr->get_next();
  }
  if (minVertex != nullptr  && minArea < this->tolerance) minVertex->remove();
  if (!vwLine->isLiving())    return -1;
  return(minArea);
}
