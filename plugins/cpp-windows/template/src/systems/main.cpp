#include "io/console_output.hpp"
#include "systems/greeter_app.hpp"

#include <cstddef>
#include <cstdlib>
#include <exception>
#include <print>
#include <span>
#include <string_view>
#include <vector>

// The embedded manifest (resources/app.manifest) sets the process code page to
// UTF-8, so argv holds UTF-8 text.
int main(int argc, char* argv[]) {
    try {
        const std::span all_arguments(argv, static_cast<std::size_t>(argc));
        const std::vector<std::string_view> arguments(all_arguments.begin() + 1, all_arguments.end());
        return run_greeter_app(arguments,
                               {.write_line = write_output_line, .write_error_line = write_error_line});
    } catch (const std::exception& error) {
        // An unexpected failure (a bug or a broken invariant): report it and
        // exit. Nothing is left to do if reporting fails too.
        try {
            std::println(stderr, "fatal error: {}", error.what());
        } catch (...) { // NOLINT(bugprone-empty-catch): see above
        }
        return EXIT_FAILURE;
    }
}
