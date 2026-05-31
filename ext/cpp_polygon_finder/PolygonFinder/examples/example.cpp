/*
 * example.cpp
 *
 * Copyright (c) 2025-2026 Emanuele Cesaroni
 *
 * Licensed under the GNU Affero General Public License v3 (AGPLv3).
 * See the LICENSE file in this directory for the full license text.
 */

#include <gperftools/malloc_extension.h>
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
  // test_suite.test_f();
  // test_suite.test_g();
  // test_suite.test_h();
  // test_suite.test_i();
  std::cout << "compute time =" << cpu_timer.stop() << std::endl;
}

int main() {
  #ifdef USE_TCMALLOC
    MallocExtension::instance()->SetNumericProperty(
      "tcmalloc.max_total_thread_cache_bytes",
      1024 * 1024 * 1024);
  #endif
  Contrek::Config cfg;
  cfg.threads = 8;
  cfg.tiles = 8;
  cfg.compress_unique = true;
  // cfg.treemap = true;
  // cfg.connectivity_mode = Contrek::Connectivity::OMNIDIRECTIONAL;

  CpuTimer cpu_timer;
  cpu_timer.start();
  std::cout << "--- Start Native Benchmark ---" << std::endl;
  // auto result = Contrek::trace("../images/graphs_1024x1024.png", cfg);
  auto result = Contrek::trace("../images/sample_10240x10240.png", cfg);
  // auto result = Contrek::trace("../images/test_20480x20480.png", cfg);
  result->print_info();
  std::cout << "Found polygons: " << result->groups << std::endl;
  std::cout << "Time: " << cpu_timer.stop() << " ms" << std::endl;
  // result->save_svg("output.svg");

  // run_test();
  return 0;
}
