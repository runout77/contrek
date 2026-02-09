/*
 * Matcher.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once

class Matcher {
 protected:
  unsigned int value;

 public:
  explicit Matcher(unsigned int value);
  virtual bool match(unsigned int value);
  virtual bool unmatch(unsigned int value);
  virtual ~Matcher();
};
