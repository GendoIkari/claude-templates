#include "business-logic/parse_arguments.hpp"

#include <catch2/catch_test_macros.hpp>

#include <array>
#include <string>
#include <string_view>

TEST_CASE("parse_arguments reads the name and the shout flag in any order") {
    constexpr std::array<std::string_view, 2> arguments{"--shout", "Ada"};

    const auto options = parse_arguments(arguments);

    REQUIRE(options.has_value());
    CHECK(options->name == "Ada");
    CHECK(options->shout);
}

TEST_CASE("parse_arguments fails without a name") {
    constexpr std::array<std::string_view, 1> arguments{"--shout"};

    const auto options = parse_arguments(arguments);

    REQUIRE_FALSE(options.has_value());
    CHECK(options.error().kind == ArgumentError::Kind::missing_name);
}

TEST_CASE("parse_arguments rejects a second name") {
    constexpr std::array<std::string_view, 2> arguments{"Ada", "Grace"};

    const auto options = parse_arguments(arguments);

    REQUIRE_FALSE(options.has_value());
    CHECK(options.error().kind == ArgumentError::Kind::extra_argument);
    CHECK(options.error().argument == "Grace");
}

TEST_CASE("parse_arguments rejects unknown options") {
    constexpr std::array<std::string_view, 2> arguments{"Ada", "--whisper"};

    const auto options = parse_arguments(arguments);

    REQUIRE_FALSE(options.has_value());
    CHECK(options.error().kind == ArgumentError::Kind::unknown_option);
    CHECK(options.error().argument == "--whisper");
}

TEST_CASE("argument_error_text names the offending argument and shows the usage") {
    const std::string text =
        argument_error_text({.kind = ArgumentError::Kind::unknown_option, .argument = "--whisper"});

    CHECK(text.contains("'--whisper'"));
    CHECK(text.contains("usage:"));
}
