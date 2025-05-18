/*
 * VisvalingamReducer.h
 *
 *  Created on: 20 dic 2018
 *      Author: ema
 *      Copyright 2025 Emanuele Cesaroni
 */

#ifndef POLYGON_REDUCERS_VISVALINGAMREDUCER_H_
#define POLYGON_REDUCERS_VISVALINGAMREDUCER_H_

#include <cmath>
#include <limits>
#include <list>
#include "Reducer.h"
#include "../finder/Node.h"

struct Point;

class VisvalingamReducer : public Reducer {
 public:
  VisvalingamReducer(std::list<Point*> *list_of_points, float tolerance);
  virtual ~VisvalingamReducer();
  void reduce();
  std::list<Point*> *simplify();
  class Triangle {
   public:
    static int area(Point *a, Point *b, Point *c) {
      return( std::abs(  ((c->x - a->x) * (b->y - a->y) - (b->x - a->x) * (c->y - a->y)) / 2));
    }
  };
    class Vertex {
      const float MAX_AREA = std::numeric_limits<float>::max();
      Vertex(Point *pt) {
        this->pt = pt;
        this->prev = nullptr;
        this->next = nullptr;
        this->area = MAX_AREA;
        this->isLive = true;
      }

     public:
      Point *pt;
      void setNext(Vertex *nextp) {
        this->next = nextp;
      }
      void setPrec(Vertex *prev) {
        this->prev = prev;
      }
      void updateArea() {
        if (this->prev == nullptr || this->next == nullptr)
        { this->area = MAX_AREA;
          return;
        }
        this->area = Triangle::area(this->prev->pt, this->pt, this->next->pt);
      }
      float getArea()
      { return(this->area);
      }
      Vertex *get_next() {
        return(this->next);
      }
      bool isLiving()
      { return(this->isLive);
      }
      static Vertex *buildLine(std::list<Point*> *pts) {
        Vertex *first = nullptr;
        Vertex *prev = nullptr;
        int i = 0;
        for (std::list<Point*>::iterator it = pts->begin(); it != pts->end(); ++it, i++)
        { Vertex *v = new Vertex(*it);
          if (first == nullptr) first = v;
          v->setPrec(prev);
          if (prev != nullptr)
          { prev->setNext(v);
            prev->updateArea();
          }
          prev = v;
        }
        return(first);
      }
      Vertex* remove() {
        Vertex *tmpPrev = this->prev;
        Vertex *tmpNext = this->next;
        Vertex *result = nullptr;
        if (this->prev != nullptr)
        { this->prev->setNext(tmpNext);
          this->prev->updateArea();
          result = prev;
        }
        if (this->next != nullptr)
        { this->next->setPrec(tmpPrev);
          this->next->updateArea();
          if (result == nullptr) result = this->next;
        }
        this->isLive = false;
        return(result);
      }
      std::list<Point*> *getCoordinates() {
        std::list<Point*> *coords = new std::list<Point*>();
        Vertex *curr = this;
        for (;;)
        { coords->push_back(curr->pt);
          curr = curr->get_next();
          if (curr == nullptr) break;
        }
        return(coords);
      }

     private:
      Vertex *next, *prev;
      double area = MAX_AREA;
      bool isLive = true;
    };

 private:
  float simplifyVertex(VisvalingamReducer::Vertex *vwLine);
  float tolerance;
};

#endif /* POLYGON_REDUCERS_VISVALINGAMREDUCER_H_ */
