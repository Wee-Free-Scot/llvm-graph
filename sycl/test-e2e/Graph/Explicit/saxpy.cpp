// REQUIRES: level_zero, gpu
// RUN: %clangxx -fsycl -fsycl-targets=%sycl_triple %s -o %t.out
// RUN: %GPU_RUN_PLACEHOLDER %t.out

// Tests creating a graph for a saxpy operation using a combination of
// host and device USM.

#include "../graph_common.hpp"

int main() {

  queue Queue{gpu_selector_v};

  if (!Queue.get_device().has(sycl::aspect::usm_host_allocations)) {
    return 0;
  }

  exp_ext::command_graph Graph{Queue.get_context(), Queue.get_device()};

  const size_t N = 1000;
  const float A = 3.0f;
  float *X = malloc_device<float>(N, Queue);
  float *Y = malloc_host<float>(N, Queue);

  auto Init = Graph.add([&](handler &CGH) {
    CGH.parallel_for(range<1>{N}, [=](id<1> idx) {
      size_t i = idx;
      X[i] = 1.0f;
      Y[i] = 2.0f;
    });
  });

  auto Compute = Graph.add([&](handler &CGH) {
    CGH.parallel_for(range<1>{N}, [=](id<1> idx) {
      size_t i = idx;
      Y[i] = A * X[i] + Y[i];
    });
  });

  Graph.make_edge(Init, Compute);

  auto ExecGraph = Graph.finalize();

  Queue.submit([&](handler &CGH) { CGH.ext_oneapi_graph(ExecGraph); }).wait();

  for (int i = 0; i < N; i++)
    assert(Y[i] == 5.0f);

  sycl::free(X, Queue);
  sycl::free(Y, Queue);

  return 0;
}
