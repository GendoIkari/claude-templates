# Compiler options for the project's own targets. Fetched dependencies do not
# get them, so their warnings never fail the build.

option(ENABLE_CLANG_TIDY "Run clang-tidy on the project's sources while building" OFF)

if(ENABLE_CLANG_TIDY)
  # The pinned clang-tidy only: a distribution one does not know the pinned
  # clang's flags and libc++ headers.
  find_program(CLANG_TIDY_EXE clang-tidy HINTS "${LLVM_MINGW_ROOT}/bin" NO_DEFAULT_PATH REQUIRED)
endif()

function(project_target_options target)
  target_compile_features(${target} PUBLIC cxx_std_26)
  set_target_properties(${target} PROPERTIES CXX_EXTENSIONS OFF COMPILE_WARNING_AS_ERROR ON)
  target_compile_options(
    ${target}
    PRIVATE -Wall
            -Wextra
            -Wpedantic
            -Wconversion
            -Wsign-conversion
            -Wshadow
            -Wnon-virtual-dtor
            -Wold-style-cast
            -Wimplicit-fallthrough)
  # Smaller <windows.h>, no min/max macros. UNICODE stays undefined, so the
  # generic Windows API names resolve to the -A functions, which take UTF-8.
  target_compile_definitions(${target} PRIVATE WIN32_LEAN_AND_MEAN NOMINMAX)
  if(ENABLE_CLANG_TIDY)
    set_target_properties(${target} PROPERTIES CXX_CLANG_TIDY "${CLANG_TIDY_EXE}")
  endif()
endfunction()
