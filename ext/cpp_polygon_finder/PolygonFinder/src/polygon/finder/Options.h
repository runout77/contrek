/*
 * Options.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include "OptionValue.h"
#include <initializer_list>
#include <map>
#include <memory>
#include <stdexcept>
#include <string>
#include <utility>
#include <sstream>


class Options {
 public:
  using Map = std::map<std::string, OptionValue>;
  using value_type = Map::value_type;
  using iterator = Map::iterator;
  using const_iterator = Map::const_iterator;

  Options() = default;

  Options(std::initializer_list<value_type> values) : values_(values) {}

  OptionValue& operator[](const std::string& key) { return values_[key]; }
  OptionValue& operator[](std::string&& key) { return values_[std::move(key)]; }
  OptionValue& at(const std::string& key) { return values_.at(key); }
  const OptionValue& at(const std::string& key) const { return values_.at(key); }
  iterator find(const std::string& key) { return values_.find(key); }
  const_iterator find(const std::string& key) const { return values_.find(key); }
  iterator begin() { return values_.begin(); }
  const_iterator begin() const { return values_.begin(); }
  const_iterator cbegin() const { return values_.cbegin(); }
  iterator end() { return values_.end(); }
  const_iterator end() const { return values_.end(); }
  const_iterator cend() const { return values_.cend(); }
  bool contains(const std::string& key) const { return values_.find(key) != values_.end();}
  bool empty() const {return values_.empty();}
  std::size_t size() const {return values_.size();}
  void clear() { values_.clear();}
  std::size_t erase(const std::string& key) { return values_.erase(key);}


  std::string to_string(int indent = 0) const {
    std::ostringstream out;
    std::string pad(indent, ' ');
    out << "{";
    bool first = true;
    for (const auto& [key, value] : values_) {
      if (!first) {
        out << ",";
      }
      out << "\n" << pad << "  " << key << ": ";
      if (value.is_bool()) {
        out << (value.as_bool() ? "true" : "false");
      } else if (value.is_integer()) {
        out << value.as_integer();
      } else if (value.is_double()) {
        out << value.as_double();
      } else if (value.is_string()) {
        out << "\"" << value.as_string() << "\"";
      } else if (value.is_identifier()) {
        out << ":" << value.as_identifier().value;
      } else if (value.is_options()) {
        out << value.as_options().to_string(indent + 2);
      } else {
        out << "nil";
      }
      first = false;
    }
    if (!values_.empty()) {
      out << "\n" << pad;
    }
    out << "}";
    return out.str();
  }

  template <typename T>
  T get(const std::string& key, T default_value) const {
    const auto it = values_.find(key);
    if (it == values_.end()) {
      return default_value;
    }
    const T* value = it->second.get_if<T>();
    return value != nullptr ? *value : default_value;
  }

  const Options* get_options(const std::string& key) const {
    const auto it = values_.find(key);
    if (it == values_.end()) {
      return nullptr;
    }
    if (!it->second.is_options()) {
      return nullptr;
    }
    return &it->second.as_options();
  }

  const Map& values() const {
    return values_;
  }

 private:
  Map values_;
};

inline OptionValue::OptionValue(const Options& value) : value_(std::make_shared<Options>(value)) {}
inline OptionValue::OptionValue(Options&& value) : value_(std::make_shared<Options>(std::move(value))) {}

inline const Options& OptionValue::as_options() const {
  const auto& options = std::get<NestedOptions>(value_);
  if (!options) {
    throw std::runtime_error("OptionValue contains null Options");
  }
  return *options;
}
