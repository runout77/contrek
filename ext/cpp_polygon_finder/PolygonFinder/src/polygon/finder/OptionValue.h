/*
 * OptionValue.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include <cstdint>
#include <memory>
#include <string>
#include <utility>
#include <variant>

class Options;

struct Identifier {
  std::string value;
  Identifier() = default;
  Identifier(const char* v) : value(v) {}
  Identifier(std::string v) : value(std::move(v)) {}
  bool operator==(const Identifier& other) const {
    return value == other.value;
  }
  bool operator!=(const Identifier& other) const {
    return value != other.value;
  }
};

class OptionValue {
 public:
  using NestedOptions = std::shared_ptr<Options>;

  using Value = std::variant<
    std::monostate,
    bool,
    std::int64_t,
    double,
    std::string,
    Identifier,
    NestedOptions>;

  OptionValue() = default;
  OptionValue(bool value) : value_(value) {}
  OptionValue(int value) : value_(static_cast<std::int64_t>(value)) {}
  OptionValue(std::int64_t value) : value_(value) {}
  OptionValue(double value) : value_(value) {}
  OptionValue(const char* value) : value_(std::string(value)) {}
  OptionValue(std::string value) : value_(std::move(value)) {}
  OptionValue(Identifier value) : value_(std::move(value)) {}
  OptionValue(const Options& value);
  OptionValue(Options&& value);
  bool is_bool() const { return std::holds_alternative<bool>(value_); }
  bool is_integer() const { return std::holds_alternative<std::int64_t>(value_); }
  bool is_double() const {return std::holds_alternative<double>(value_);}
  bool is_string() const { return std::holds_alternative<std::string>(value_); }
  bool is_options() const { return std::holds_alternative<NestedOptions>(value_); }
  bool is_identifier() const { return std::holds_alternative<Identifier>(value_); }
  bool as_bool() const { return std::get<bool>(value_); }
  std::int64_t as_integer() const { return std::get<std::int64_t>(value_); }
  double as_double() const { return std::get<double>(value_); }
  const std::string& as_string() const { return std::get<std::string>(value_); }
  std::string& as_string() { return std::get<std::string>(value_); }
  const Options& as_options() const;
  Options& as_options();
  const Identifier& as_identifier() const { return std::get<Identifier>(value_); }
  Identifier& as_identifier() { return std::get<Identifier>(value_);}

  template <typename T>
  bool is() const { return std::holds_alternative<T>(value_); }

  template <typename T>
  const T& as() const { return std::get<T>(value_); }

  template <typename T>
  T& as() { return std::get<T>(value_);}

  template <typename T>
  const T* get_if() const { return std::get_if<T>(&value_); }

  template <typename T>
  T* get_if() {return std::get_if<T>(&value_); }

  const Value& value() const { return value_; }
  Value& value() {return value_;}

 private:
  Value value_;
};
