#include "business-logic/parse_arguments.hpp"

#include <format>
#include <utility>

std::expected<GreetingOptions, ArgumentError> parse_arguments(std::span<const std::string_view> arguments) {
    GreetingOptions options;
    bool has_name = false;
    for (const std::string_view argument : arguments) {
        if (argument == "--shout") {
            options.shout = true;
        } else if (argument.starts_with("--")) {
            return std::unexpected(ArgumentError{.kind = ArgumentError::Kind::unknown_option,
                                                 .argument = std::string(argument)});
        } else if (has_name) {
            return std::unexpected(ArgumentError{.kind = ArgumentError::Kind::extra_argument,
                                                 .argument = std::string(argument)});
        } else {
            options.name = argument;
            has_name = true;
        }
    }
    if (!has_name) {
        return std::unexpected(ArgumentError{.kind = ArgumentError::Kind::missing_name, .argument = {}});
    }
    return options;
}

std::string argument_error_text(const ArgumentError& error) {
    constexpr std::string_view usage = "usage: <name> [--shout]";
    switch (error.kind) {
    case ArgumentError::Kind::missing_name:
        return std::format("missing name\n{}", usage);
    case ArgumentError::Kind::extra_argument:
        return std::format("unexpected argument '{}'\n{}", error.argument, usage);
    case ArgumentError::Kind::unknown_option:
        return std::format("unknown option '{}'\n{}", error.argument, usage);
    }
    std::unreachable();
}
