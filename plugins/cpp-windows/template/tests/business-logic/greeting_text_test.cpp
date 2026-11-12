#include "business-logic/greeting_text.hpp"

#include <catch2/catch_test_macros.hpp>

TEST_CASE("greeting_text greets the name") {
    CHECK(greeting_text({.name = "Ada", .shout = false}) == "Hello, Ada!");
}

TEST_CASE("greeting_text shouts in ASCII upper case and keeps other UTF-8 text") {
    CHECK(greeting_text({.name = "Zoë", .shout = true}) == "HELLO, ZOë!");
}
