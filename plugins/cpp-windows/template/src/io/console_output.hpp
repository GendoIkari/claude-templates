#pragma once

#include <string_view>

/// Writes UTF-8 text and a newline to standard output.
void write_output_line(std::string_view text);

/// Writes UTF-8 text and a newline to standard error.
void write_error_line(std::string_view text);
