#pragma once

#include <string>

/// An expected failure while reading the command line.
struct ArgumentError {
    enum class Kind { missing_name, extra_argument, unknown_option };

    Kind kind;
    /// The offending argument; empty for `missing_name`.
    std::string argument;
};
