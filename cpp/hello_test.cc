#include <cassert>
#include <iostream>
#include "cpp/hello.h"
int main() { assert(Greeting() == "Hello from C++ + Bazel!"); std::cout << "C++ hello_test passed\\n"; return 0; }
