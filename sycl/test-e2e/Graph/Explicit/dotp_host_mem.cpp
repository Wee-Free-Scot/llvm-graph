// REQUIRES: level_zero, gpu
// RUN: %clangxx -fsycl -fsycl-targets=%sycl_triple %s -o %t.out
// RUN: %GPU_RUN_PLACEHOLDER %t.out

// Tests using USM host memory with an explicitly constructed graph.

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

  auto NodeI = Graph.add([&](handler &CGH) {
    CGH.parallel_for(N, [=](id<1> it) {
      const size_t i = it[0];
      X[i] = 1.0f;
      Y[i] = 2.0f;
      Z[i] = 3.0f;
    });
  });

  auto NodeA = Graph.add(
      [&](handler &CGH) {
        CGH.parallel_for(range<1>{N}, [=](id<1> it) {
          const size_t i = it[0];
          X[i] = Alpha * X[i] + Beta * Y[i];
        });
      },
      {exp_ext::property::node::depends_on(NodeI)});

  auto NodeB = Graph.add(
      [&](handler &CGH) {
        CGH.parallel_for(range<1>{N}, [=](id<1> it) {
          const size_t i = it[0];
          Z[i] = Gamma * Z[i] + Beta * Y[i];
        });
      },
      {exp_ext::property::node::depends_on(NodeI)});

  auto NodeC = Graph.add(
      [&](handler &CGH) {
        CGH.single_task([=]() {
          for (size_t j = 0; j < N; j++) {
            Dotp[0] += X[j] * Z[j];
          }
        });
      },
      {exp_ext::property::node::depends_on(NodeA, NodeB)});

  auto ExecGraph = Graph.finalize();

  // Using shortcut for executing a graph of commands
  Queue.ext_oneapi_graph(ExecGraph).wait();

  assert(*Dotp == dotp_reference_result(N));

  sycl::free(Dotp, Queue);
  sycl::free(X, Queue);
  sycl::free(Y, Queue);
  sycl::free(Z, Queue);

  return 0;
}
