//============================================================================
// Name        : example.cpp
// Author      : Emanuele Cesaroni
// Version     :
// Copyright   : 2025 Emanuele Cesaroni
// Description :
//============================================================================

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
  cfg.threads = 2;
  cfg.tiles = 2;
  cfg.compress_unique = true;

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
