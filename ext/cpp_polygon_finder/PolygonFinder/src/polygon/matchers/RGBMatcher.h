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

class RGBMatcher : public Matcher {
 public:
  explicit RGBMatcher(unsigned int rgb_value);
  virtual ~RGBMatcher();
  bool match(unsigned int value) override;
 private:
  unsigned int rgb_value;
};
