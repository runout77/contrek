/*
 * VisvalingamReducer.h
 *
 *  Created on: 20 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#pragma once
#include <vector>
#include <cmath>
#include <limits>
#include "Reducer.h"

struct Point;

class VisvalingamReducer : public Reducer {
 public:
  VisvalingamReducer(std::vector<Point*>& list_of_points, float tolerance);
  virtual ~VisvalingamReducer();
  void reduce();
  std::vector<Point*> simplify();

  class Triangle {
   public:
    static int area(Point* a, Point* b, Point* c) {
      return std::abs(((c->x - a->x) * (b->y - a->y) - (b->x - a->x) * (c->y - a->y)) / 2);
    }
  };

  class Vertex {
    const float MAX_AREA = std::numeric_limits<float>::max();
    explicit Vertex(Point* pt) {
      this->pt = pt;
      this->prev = nullptr;
      this->next = nullptr;
      this->area = MAX_AREA;
      this->isLive = true;
    }

   public:
    Point* pt;
    void setNext(Vertex* nextp) { this->next = nextp; }
    void setPrec(Vertex* prev) { this->prev = prev; }
    void updateArea() {
      if (!prev || !next)
      { this->area = MAX_AREA;
        return;
      }
      this->area = Triangle::area(this->prev->pt, this->pt, this->next->pt);
    }
    float getArea() { return this->area; }
    Vertex* get_next() { return this->next; }
    bool isLiving() { return this->isLive; }

    static Vertex* buildLine(std::vector<Point*>& pts) {
      Vertex* first = nullptr;
      Vertex* prev = nullptr;
      for (Point* p : pts) {
        Vertex* v = new Vertex(p);
        if (!first) first = v;
        v->setPrec(prev);
        if (prev) {
            prev->setNext(v);
            prev->updateArea();
        }
        prev = v;
      }
      return first;
    }

    Vertex* remove() {
      Vertex* tmpPrev = this->prev;
      Vertex* tmpNext = this->next;
      Vertex* result = nullptr;
      if (tmpPrev) {
        tmpPrev->setNext(tmpNext);
        tmpPrev->updateArea();
        result = tmpPrev;
      }
      if (tmpNext) {
        tmpNext->setPrec(tmpPrev);
        tmpNext->updateArea();
        if (!result) result = tmpNext;
      }
      this->isLive = false;
      return result;
    }

    static std::vector<Point*> getCoordinates(Vertex* head) {
      std::vector<Point*> coords;
      Vertex* curr = head;
      while (curr) {
        coords.push_back(curr->pt);
        curr = curr->get_next();
      }
      return coords;
    }

   private:
    Vertex* next;
    Vertex* prev;
    float area;
    bool isLive;
  };

 private:
  float simplifyVertex(Vertex* vwLine);
  float tolerance;
};
