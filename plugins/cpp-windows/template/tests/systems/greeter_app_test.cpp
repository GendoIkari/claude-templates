#include "systems/greeter_app.hpp"

#include <catch2/catch_test_macros.hpp>

#include <array>
#include <cstdlib>
#include <string>
#include <string_view>
#include <vector>

namespace {

/// Records what the greeter writes, in place of the console.
struct RecordedOutput {
    std::vector<std::string> lines;
    std::vector<std::string> error_lines;

    [[nodiscard]] GreeterOutput as_greeter_output() {
        return {.write_line = [this](std::string_view text) { lines.emplace_back(text); },
                .write_error_line = [this](std::string_view text) { error_lines.emplace_back(text); }};
    }
};

} // namespace

TEST_CASE("run_greeter_app writes the greeting and succeeds") {
    RecordedOutput output;
    constexpr std::array<std::string_view, 1> arguments{"Ada"};

    const int exit_code = run_greeter_app(arguments, output.as_greeter_output());

    CHECK(exit_code == EXIT_SUCCESS);
    CHECK(output.lines == std::vector<std::string>{"Hello, Ada!"});
    CHECK(output.error_lines.empty());
}

TEST_CASE("run_greeter_app reports invalid arguments on the error output and fails") {
    RecordedOutput output;
    constexpr std::array<std::string_view, 0> arguments{};

    const int exit_code = run_greeter_app(arguments, output.as_greeter_output());

    CHECK(exit_code == EXIT_FAILURE);
    CHECK(output.lines.empty());
    REQUIRE(output.error_lines.size() == 1);
    CHECK(output.error_lines.front().starts_with("missing name"));
}
