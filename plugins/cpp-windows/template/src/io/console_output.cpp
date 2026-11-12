#include "io/console_output.hpp"

#include <cstdio>
#include <print>

void write_output_line(std::string_view text) {
    std::println(stdout, "{}", text);
}

void write_error_line(std::string_view text) {
    std::println(stderr, "{}", text);
}
