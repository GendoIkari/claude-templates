# Code architecture: models, business logic, I/O, systems

Every project is split into four layers, each in its own directory under the source root. The structure must be visible in the filesystem, so an agent can discover it with `ls`.

| Directory | Contains | May depend on |
| --- | --- | --- |
| `models/` | Plain data definitions. No behavior beyond construction and validation of their own invariants. No I/O. | other models only |
| `business-logic/` | Pure functions. They take models and plain values as input and return new or updated models or results. No I/O, no global or hidden state, no clock, randomness or environment access: these are passed in as arguments. | models |
| `io/` | Every interaction with the outside world: files, network, databases, processes, console, clock, randomness, environment variables. Thin adapters that convert between external formats and models. No business decisions. | models |
| `systems/` | Own the state: instantiate models, hold data, call business logic and I/O. Entry points and wiring live here. | models, business-logic, io |

The stack template sets the source root and the exact directory names, adapted to the language where a hyphen is not allowed (for example `business_logic/` in Python).

- Business logic never imports from `io/` or `systems/`. Models never import from another layer.
- In business logic, prefer returning new values over mutating inputs.
- When code needs both a decision and a side effect, split it: the decision goes in business logic, the side effect in io, and a system connects them.
- Tests follow the layers: unit tests cover business logic and model invariants; system tests exercise systems end to end, with real I/O or with fakes at the io boundary.

## File names for discoverability

- Name every file after what it contains, precisely enough that a directory listing tells an agent what exists (for example `invoice_totals`, `parse_order_csv`, `order_repository_postgres`). Never use vague names such as `utils`, `helpers`, `common`, `misc`, `manager`, `core`.
- One cohesive concept per file. When a file gains a second concept, split it.
- Keep directories flat. Add a subdirectory only for a clear sub-domain, and name it as descriptively as a file.
- Test files mirror the name of the file they test.
