#pragma once

#include "models/greeting_options.hpp"

#include <string>

/// The greeting for `options.name`, in ASCII upper case when `options.shout`.
[[nodiscard]] std::string greeting_text(const GreetingOptions& options);
