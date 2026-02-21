/*
 * example.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <iostream>
#include "ContrekApi.h"
#include "Tests.h"

void run_test() {
  CpuTimer cpu_timer;
  Tests test_suite;
  cpu_timer.start();

  // test_suite.test_a();
  // test_suite.test_b();
  // test_suite.test_c();
  // test_suite.test_d();
  // test_suite.test_e();
  test_suite.test_f();
  std::cout << "compute time =" << cpu_timer.stop() << std::endl;
}

int main() {
  Contrek::Config cfg;
  cfg.threads = 4;
  cfg.tiles = 4;
  cfg.compress_unique = true;
  cfg.connectivity_mode = Contrek::Connectivity::OMNIDIRECTIONAL;

  CpuTimer cpu_timer;
  cpu_timer.start();
  std::cout << "--- Start Native Benchmark ---" << std::endl;
  auto result = Contrek::trace("../images/sample_10240x10240.png", cfg);
  result->print_info();
  std::cout << "Found polygons: " << result->groups << std::endl;
  std::cout << "Time: " << cpu_timer.stop() << " ms" << std::endl;

  // run_test();
  return 0;
}
