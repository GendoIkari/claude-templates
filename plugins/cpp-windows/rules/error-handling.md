# C++ error handling

This project's single error-handling approach, as the base error-handling rule requires:

- Expected failures (invalid input, a missing file, a refused connection) are values, not exceptions. Functions that can fail this way return `std::expected<T, E>`, where `E` is a model in `src/models/` that describes the failures the caller must handle: a struct with an `enum class Kind` and the details each kind needs (`src/models/argument_error.hpp` is the reference).
- Business logic returns `std::expected` and never throws for expected failures.
- I/O adapters catch exceptions from the standard library and third-party libraries at the boundary, and check Windows API return values and `GetLastError()`, converting both into `std::expected` failures. Nothing else catches exceptions.
- Unexpected failures (bugs, broken invariants) are thrown as standard exceptions (`std::logic_error` and its subclasses) and are never caught locally. `main` catches `std::exception` only to print `fatal error: <message>` to stderr and exit with `EXIT_FAILURE`.
- Systems decide what an expected failure means for the user: they route it to the user with a message built by a business-logic function (`argument_error_text`), and choose the exit code (or the UI state) they return to `main`.
- Never ignore a returned `std::expected` or error code: functions that return one are `[[nodiscard]]`. Mark an intentionally discarded value with `(void)` and a comment saying why.
