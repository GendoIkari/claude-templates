# cpp-windows

Stack template for C++ apps for Windows. It builds on `coding-base-windows` (environment, layers, quality gates, reviewers) and `gitflow` (one worktree per feature, fast-forward-only `master`), which it declares as dependencies.

## Install

```
/plugin install cpp-windows --marketplace GendoIkari/claude-templates
/coding-base-windows:setup
/gitflow:setup
/cpp-windows:setup [app_name]
```

In a project without `CMakeLists.txt`, `setup` applies the template and installs the toolchain. In an existing project it only installs the rules and reports how the project differs from the template.

## Stack

C++26 with CMake presets and Ninja, cross-compiled in WSL for Windows x86-64 with [llvm-mingw](https://github.com/mstorsjo/llvm-mingw) (clang, libc++, lld, UCRT). The toolchain and CMake are pinned with their SHA-256 in `cmake/toolchain.env` and installed per user in `~/.local/opt`, so every machine builds with the same compiler. Dependencies come from release archives through `FetchContent`, pinned by hash and built as static libraries. Quality gates: clang-format, compiler warnings as errors, clang-tidy as errors, Catch2 tests run as Windows executables through WSL interop.

## Contents

| Component | Purpose |
| --- | --- |
| `rules/stack.md` | Toolchain, static linking, UTF-8, dependencies, commands, build command |
| `rules/structure.md` | Layers under `src/`, CMake targets, file and naming conventions |
| `rules/testing.md` | Catch2 tests and fakes at the io boundary |
| `rules/error-handling.md` | `std::expected` for expected failures, exceptions for bugs |
| `/cpp-windows:setup` | Installs the rules and scaffolds the app |
| `setup/scaffold.sh` | Applies `template/`, sets the app name and installs the toolchain |
| `template/` | CMake project and presets, llvm-mingw toolchain file, pinned versions, dependencies, clang-format and clang-tidy configuration, layered example app with tests, UTF-8 manifest, `scripts/project.sh` |

## Static executables

The toolchain file links with `-static`, so libc++, libunwind, winpthreads and the compiler runtime are inside the executable. It imports only `KERNEL32.dll` and the UCRT (`api-ms-win-crt-*`), which ship with Windows 10 and later: `build/release/<app>.exe` runs on its own, without DLLs or redistributables. Its embedded manifest makes UTF-8 the process code page on Windows 10 1903 and later.

## Why not MSVC

The base template runs every tool in WSL. llvm-mingw cross-compiles from there without Visual Studio, ships the newest clang and libc++, and links fully statically. The executables do not use the MSVC ABI: libraries distributed only as MSVC binaries cannot be linked, which is one more reason to build every dependency from source with `FetchContent`.

## Known limits

- Tests run as Windows executables, so WSL interop must be enabled.
- Catch2's `catch_discover_tests` passes Linux paths that Catch2 on Windows reads as options, so CTest runs the test executable as a single test; Catch2 still reports each failing test case.
- clangd or an IDE on Windows cannot use the WSL toolchain directly; code intelligence needs an editor connected to WSL (for example VS Code with the WSL extension) pointed at `build/debug/compile_commands.json`.
