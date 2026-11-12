#pragma once

#include "models/argument_error.hpp"
#include "models/greeting_options.hpp"

#include <expected>
#include <span>
#include <string>
#include <string_view>

/// Reads `<name> [--shout]` from the command-line arguments that follow the
/// program name.
[[nodiscard]] std::expected<GreetingOptions, ArgumentError>
parse_arguments(std::span<const std::string_view> arguments);

/// A message for the user that explains the failure and the expected usage.
[[nodiscard]] std::string argument_error_text(const ArgumentError& error);
