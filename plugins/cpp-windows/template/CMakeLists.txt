cmake_minimum_required(VERSION 4.4)

project(@APP_NAME@ LANGUAGES CXX RC)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
include(project-target-options)
include(dependencies)

# Everything except the entry point, so tests can link it.
add_library(${PROJECT_NAME}_lib STATIC
  src/business-logic/greeting_text.cpp
  src/business-logic/parse_arguments.cpp
  src/io/console_output.cpp
  src/systems/greeter_app.cpp)
target_include_directories(${PROJECT_NAME}_lib PUBLIC src)
project_target_options(${PROJECT_NAME}_lib)

# resources/app.rc embeds the UTF-8 manifest; every executable links it.
add_executable(${PROJECT_NAME} src/systems/main.cpp resources/app.rc)
target_link_libraries(${PROJECT_NAME} PRIVATE ${PROJECT_NAME}_lib)
project_target_options(${PROJECT_NAME})

enable_testing()
add_executable(${PROJECT_NAME}_tests
  tests/business-logic/greeting_text_test.cpp
  tests/business-logic/parse_arguments_test.cpp
  tests/systems/greeter_app_test.cpp
  resources/app.rc)
target_link_libraries(${PROJECT_NAME}_tests PRIVATE ${PROJECT_NAME}_lib Catch2::Catch2WithMain)
project_target_options(${PROJECT_NAME}_tests)

# One CTest test runs every Catch2 test case. WSL runs the Windows executable
# through its interop. catch_discover_tests is not used: it passes Linux paths,
# which Catch2 on Windows reads as options because they start with '/'.
add_test(NAME ${PROJECT_NAME}_tests COMMAND ${PROJECT_NAME}_tests --order rand --warn NoAssertions)
