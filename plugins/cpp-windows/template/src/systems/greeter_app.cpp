#include "systems/greeter_app.hpp"

#include "business-logic/greeting_text.hpp"
#include "business-logic/parse_arguments.hpp"

#include <cstdlib>

int run_greeter_app(std::span<const std::string_view> arguments, const GreeterOutput& output) {
    const auto options = parse_arguments(arguments);
    if (!options) {
        output.write_error_line(argument_error_text(options.error()));
        return EXIT_FAILURE;
    }
    output.write_line(greeting_text(*options));
    return EXIT_SUCCESS;
}
