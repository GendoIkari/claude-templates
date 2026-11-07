/**
 * Outcome of an operation that can fail in an expected way, such as invalid
 * input or a missing record. `E` is a discriminated union of the failures the
 * caller must handle. Unexpected failures (bugs, broken invariants) are thrown.
 */
export type Result<T, E> = { ok: true; value: T } | { ok: false; error: E };

export const ok = <T>(value: T): Result<T, never> => ({ ok: true, value });

export const err = <E>(error: E): Result<never, E> => ({ ok: false, error });
