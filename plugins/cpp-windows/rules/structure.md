# C++ structure: layers, targets, files

The base architecture rule (models / business logic / io / systems) maps onto the project like this. The source root is `src/`, which is the include root: include project headers by their path from it (`#include "business-logic/greeting_text.hpp"`).

| Directory | Contains | May include |
| --- | --- | --- |
| `src/models/` | Structs and enums, with validation of their own invariants | models |
| `src/business-logic/` | Free functions without side effects | models |
| `src/io/` | Files, console, network, processes, clock, randomness, environment, Windows API calls | models |
| `src/systems/` | State and wiring; `main.cpp` is the entry point | models, business-logic, io |
| `tests/` | Catch2 tests, mirroring `src/` (`tests/business-logic/greeting_text_test.cpp`) | everything in `src/` |
| `resources/` | Windows resources: manifest, icons, version info, compiled through `app.rc` | nothing |
| `cmake/` | Toolchain file, pinned versions, dependencies, compiler options | nothing |

## Targets

`CMakeLists.txt` defines three targets; add every new source file to the right one by name (no globbing):

- `<app>_lib`: a static library with every source file except `src/systems/main.cpp`.
- `<app>`: the executable, `src/systems/main.cpp` plus `resources/app.rc`, linking `<app>_lib`.
- `<app>_tests`: the Catch2 test executable, every file under `tests/` plus `resources/app.rc`, linking `<app>_lib` and `Catch2::Catch2WithMain`.

Every project target calls `project_target_options(<target>)` from `cmake/project-target-options.cmake`, which sets C++26, the warning flags, warnings as errors and clang-tidy. A new executable or library gets the same call. Never relax these options for one target or one file.

## Files and names

- Each `.cpp` file except `src/systems/main.cpp` has a header with the same name next to it; headers use `#pragma once`.
- File names are snake_case and describe the content (`parse_arguments.cpp`, `order_repository_sqlite.cpp`). Types are `CamelCase`; functions, variables and enum values are `snake_case` (clang-tidy enforces it).
- Prefer free functions and plain structs. Use a class only to own an invariant or a resource (RAII), in models or io.
- Pass read-only inputs as `std::string_view`, `std::span<const T>` or `const T&`.
- A system receives its io as a parameter (a struct of `std::function`s, like `GreeterOutput` in `src/systems/greeter_app.hpp`), so tests can pass fakes; `main.cpp` connects it to the real io functions.
- No raw `new`/`delete`, no owning raw pointers, no C casts, no global mutable state.
