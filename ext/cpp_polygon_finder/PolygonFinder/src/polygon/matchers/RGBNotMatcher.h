/*
 * RGBMatcher.h
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#pragma once
#include "Matcher.h"

class RGBNotMatcher : public Matcher {
 public:
  explicit RGBNotMatcher(unsigned int rgb_value);
  virtual ~RGBNotMatcher();
  bool match(unsigned int value) override;
 private:
  unsigned int rgb_value;
};
