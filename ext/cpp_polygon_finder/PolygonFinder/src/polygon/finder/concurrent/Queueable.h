/*
 * Queueable.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <vector>
#include <list>
#include <functional>
#include <stdexcept>
#include <iostream>

template <typename T>
class Queueable;

template <typename T>
class QNode {
 public:
  T* payload;
  QNode<T>* next  {nullptr};
  QNode<T>* prev  {nullptr};
  Queueable<T>* owner {nullptr};
  explicit QNode(T* value) : payload(value) {}
  virtual ~QNode() = default;
  virtual void before_rem(Queueable<T>* q) {}
  virtual void after_add(Queueable<T>* q) {}
};


template <typename T>
class Queueable {
 public:
  QNode<T>* head {nullptr};
  QNode<T>* tail {nullptr};
  QNode<T>* _iterator {nullptr};
  bool _started = false;
  size_t size {0};
  virtual bool listable() const { return false; }
  Queueable() = default;
  virtual ~Queueable() = default;

  QNode<T>* rem(QNode<T>* node) {
    if (!node) return nullptr;
    // if (node->owner != this) throw std::runtime_error("Not my node");
    node->before_rem(this);
    if (node->prev) node->prev->next = node->next;
    if (node->next) node->next->prev = node->prev;
    if (node == head) head = node->next;
    if (node == tail) tail = node->prev;
    node->next = nullptr;
    node->prev = nullptr;
    node->owner = nullptr;
    if (size > 0) size--;
    return node;
  }

  void add(QNode<T>* node) {
    if (!node) return;
    if (node->owner)
        node->owner->rem(node);
    if (tail) {
        tail->next = node;
        node->prev = tail;
    } else {
        head = node;
        node->prev = nullptr;
    }
    tail = node;
    node->next = nullptr;
    node->owner = this;
    size++;
    node->after_add(this);
  }

  void rewind() {
    _iterator = nullptr;
    _started = false;
  }

  QNode<T>* iterator() const {
    if (!_started)  return head;
    return _iterator;
  }

  void forward() {
    if (!_started)
    { _iterator = head ? head->next : nullptr;
      _started = true;
    } else if (_iterator) {
      _iterator = _iterator->next;
    }
  }

  void next_of(QNode<T>* node) {
    // if (!node)  throw std::runtime_error("nil node");
    // if (node->owner != this) throw std::runtime_error("wrong node");
    _iterator = node->next;
    _started = true;
  }

  template<typename Func>
  void each(Func func) {
    QNode<T>* current = head;
    while (current) {
      if (!func(current)) break;
      current = current->next;
    }
  }

  template<typename Func>
  void reverse_each(Func func) {
    QNode<T>* current = tail;
    while (current) {
      if (!func(current)) break;
      current = current->prev;
    }
  }

  template<typename Func>
  void move_from(Queueable<T>& queueable, Func func) {
    queueable.rewind();
    while (QNode<T>* node = queueable.iterator())
    { queueable.forward();
      if (func(node)) add(node);
    }
  }

  std::vector<T*> to_vector() const {
    std::vector<T*> out;
    out.reserve(this->size);
    QNode<T>* current = head;
    while (current) {
        out.push_back(current->payload);
        current = current->next;
    }
    return out;
  }

  std::vector<T> map(std::function<T(QNode<T>*)> fn) {
      std::vector<T> out;
      each([&](QNode<T>* n){
          out.push_back(fn(n));
      });
      return out;
  }

  QNode<T>* pop() {
    if (!tail) return nullptr;
    return rem(tail);
  }
};
