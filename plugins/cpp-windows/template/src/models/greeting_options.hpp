#pragma once

#include <string>

/// What the user asked the greeter to do.
struct GreetingOptions {
    std::string name;
    bool shout = false;
};
