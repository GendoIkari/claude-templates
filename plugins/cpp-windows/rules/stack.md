# C++ stack: CMake, llvm-mingw, static Windows executables

This project is a C++26 app for 64-bit Windows, built with CMake and Ninja and cross-compiled in WSL with llvm-mingw (clang, libc++, lld, UCRT). It follows the base rules of `coding-base-windows` and the workflow of `gitflow`; this file fills in what they leave to the stack template.

- The toolchain is pinned in `cmake/toolchain.env` (llvm-mingw and CMake, each with its SHA-256) and installed per user into `~/.local/opt` (or `$TOOLCHAINS_DIR`) by `scripts/project.sh install-toolchain`. Never use the distribution's compilers or CMake, a MinGW-w64 GCC, or MSVC. To upgrade, change a version and its SHA-256 together and run the gates.
- Every command goes through `scripts/project.sh`, which puts the pinned toolchain first on `PATH` and tells the CMake toolchain file where it is (`LLVM_MINGW_ROOT`); CMake run any other way fails to configure. Run a tool that has no subcommand with `bash scripts/project.sh exec <tool> ...`.
- Use the latest standard and library: `std::expected`, `std::format`/`std::print`, ranges, `std::span`, designated initializers. No GNU extensions (`CXX_EXTENSIONS OFF`).
- Every executable is linked statically (`-static` in `cmake/llvm-mingw-x86_64.cmake`): it imports only DLLs that ship with Windows 10 and later (`KERNEL32.dll`, the `api-ms-win-crt-*` UCRT). Check with `bash scripts/project.sh exec llvm-objdump -p <exe> | grep "DLL Name"` after adding a dependency or a Windows library. Never ship a DLL next to the executable.
- Text is UTF-8 everywhere, in `std::string` and `std::string_view`. The manifest embedded through `resources/app.rc` sets the process code page to UTF-8 (Windows 10 1903 and later), so `argv`, the C runtime and the `-A` Windows API functions take UTF-8. Every executable, the test executable included, links `resources/app.rc`. Write to the console with `std::print`/`std::println`, which use the console's Unicode API.
- Windows API headers are available (`<windows.h>`, with `WIN32_LEAN_AND_MEAN` and `NOMINMAX` defined). `UNICODE` is not defined, so generic names (`CreateFile`, `MessageBox`) resolve to the `-A` functions and take UTF-8 strings; never use `wchar_t`, `TCHAR` or the `-W` functions. Link system libraries by name (`target_link_libraries(... PRIVATE user32)`); they are import libraries of DLLs that ship with Windows, so they keep the executable self-contained. A GUI app sets `WIN32_EXECUTABLE ON` on its target.

## Dependencies

- Every third-party dependency is declared in `cmake/dependencies.cmake` with `FetchContent_Declare`, from the URL of a release archive pinned with `URL_HASH SHA256=...`, with `SYSTEM` (its headers raise no warnings) and `EXCLUDE_FROM_ALL`. Never use `find_package` for third-party code, system packages, git submodules, vcpkg or Conan, and never copy a library's sources into the project.
- Dependencies build as static libraries (`BUILD_SHARED_LIBS OFF`). Set a dependency's own options (tests, examples, shared builds off) with `set(<OPTION> OFF CACHE BOOL "" FORCE)` before `FetchContent_MakeAvailable`.
- Before adding a dependency, check that the standard library does not already cover the need. Prefer libraries that build with CMake and support MinGW.
- Get the SHA-256 by downloading the archive in WSL and running `sha256sum` on it.

## Commands

| Purpose | Command |
| --- | --- |
| All quality gates | `bash scripts/project.sh gates` (clang-format check, configure, build with warnings and clang-tidy as errors, tests), run on an ext4 copy with preparation command `bash scripts/project.sh install-toolchain`, as the quality-gate rules describe |
| Fix formatting | `bash scripts/project.sh format` |
| Debug build and tests | `bash scripts/project.sh build debug` (output in `build/debug/`) |
| Release build | `bash scripts/project.sh build` (output in `build/release/`) |
| Run the app | `build/release/<app>.exe [args]` from WSL, which starts Windows executables through its interop |

## Worktrees and builds

- A fresh worktree needs no preparation: the toolchain is shared per user, and dependencies are fetched by the first configure into `build/<preset>/_deps/`.
- The build command run in the main checkout after every merge is `bash scripts/project.sh install-toolchain && bash scripts/project.sh build`. The runnable app is `build/release/<app>.exe`, a single self-contained file.
- The only build target is Windows x86-64. There is no Linux build.
- Everything the tools generate is under `build/`, which is in `.gitignore`. Add new tool outputs there too.
