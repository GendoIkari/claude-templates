# C++ testing

The tests use Catch2 v3, fetched like every other dependency. They compile into one Windows executable, `<app>_tests`, which CTest runs through WSL's interop as part of `bash scripts/project.sh gates`, in random order.

| What | How | Reference |
| --- | --- | --- |
| Models and business logic | Plain Catch2 test cases on inputs and outputs | `tests/business-logic/parse_arguments_test.cpp` |
| Systems | Catch2 test cases that run the system with fakes at the io boundary, or with real I/O on a temporary directory | `tests/systems/greeter_app_test.cpp` |

- Test files mirror `src/`: `src/<layer>/<name>.cpp` is tested by `tests/<layer>/<name>_test.cpp`.
- Name each `TEST_CASE` after the behavior it proves (`"parse_arguments rejects unknown options"`), and structure it as arrange, act, assert.
- Use `REQUIRE` when the rest of the test cannot run without it (a value is present), `CHECK` for everything else.
- Never call real external services from tests.
- Run a subset while working with `build/debug/<app>_tests.exe "<test name or [tag]>"` after `bash scripts/project.sh build debug`.
