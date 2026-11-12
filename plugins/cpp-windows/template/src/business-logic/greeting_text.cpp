#include "business-logic/greeting_text.hpp"

#include <algorithm>
#include <format>

namespace {

char ascii_upper(char character) {
    return character >= 'a' && character <= 'z' ? static_cast<char>(character - 'a' + 'A') : character;
}

} // namespace

std::string greeting_text(const GreetingOptions& options) {
    std::string text = std::format("Hello, {}!", options.name);
    if (options.shout) {
        std::ranges::transform(text, text.begin(), ascii_upper);
    }
    return text;
}
