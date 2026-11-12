#pragma once

#include <functional>
#include <span>
#include <string_view>

/// Where the greeter writes. `main` connects it to the console
/// (io/console_output.hpp); tests pass fakes that record the lines.
struct GreeterOutput {
    std::function<void(std::string_view)> write_line;
    std::function<void(std::string_view)> write_error_line;
};

/// Runs the greeter with the command-line arguments that follow the program
/// name and returns the process exit code.
[[nodiscard]] int run_greeter_app(std::span<const std::string_view> arguments, const GreeterOutput& output);
