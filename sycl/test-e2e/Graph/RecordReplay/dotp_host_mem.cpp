// REQUIRES: level_zero, gpu
// RUN: %clangxx -fsycl -fsycl-targets=%sycl_triple %s -o %t.out
// RUN: %GPU_RUN_PLACEHOLDER %t.out

// Tests a dotp operation constructed by graph recording using host USM.

#include "../graph_common.hpp"

int main() {

  queue Queue{gpu_selector_v};

  if (!Queue.get_device().has(sycl::aspect::usm_host_allocations)) {
    return 0;
  }

  exp_ext::command_graph Graph{Queue.get_context(), Queue.get_device()};

  float *Dotp = malloc_host<float>(1, Queue);

  const size_t N = 10;
  float *X = malloc_device<float>(N, Queue);
  float *Y = malloc_device<float>(N, Queue);
  float *Z = malloc_device<float>(N, Queue);

  Graph.begin_recording(Queue);

  auto InitEvent = Queue.submit([&](handler &CGH) {
    CGH.parallel_for(N, [=](id<1> it) {
      const size_t i = it[0];
      X[i] = 1.0f;
      Y[i] = 2.0f;
      Z[i] = 3.0f;
    });
  });

  auto EventA = Queue.submit([&](handler &CGH) {
    CGH.depends_on(InitEvent);
    CGH.parallel_for(range<1>{N}, [=](id<1> it) {
      const size_t i = it[0];
      X[i] = Alpha * X[i] + Beta * Y[i];
    });
  });

  auto EventB = Queue.submit([&](handler &CGH) {
    CGH.depends_on(InitEvent);
    CGH.parallel_for(range<1>{N}, [=](id<1> it) {
      const size_t i = it[0];
      Z[i] = Gamma * Z[i] + Beta * Y[i];
    });
  });

  Queue.submit([&](handler &CGH) {
    CGH.depends_on({EventA, EventB});
    CGH.single_task([=]() {
      for (size_t j = 0; j < N; j++) {
        Dotp[0] += X[j] * Z[j];
      }
    });
  });

  Graph.end_recording();

  auto ExecGraph = Graph.finalize();

  Queue.submit([&](handler &CGH) { CGH.ext_oneapi_graph(ExecGraph); }).wait();

  assert(*Dotp == dotp_reference_result(N));

  sycl::free(Dotp, Queue);
  sycl::free(X, Queue);
  sycl::free(Y, Queue);
  sycl::free(Z, Queue);

  return 0;
}
