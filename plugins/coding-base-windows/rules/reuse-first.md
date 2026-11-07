# Reuse before writing

Before writing any new function, type or module:

1. List the relevant layer directories and search the project for code that does the same or a similar job.
2. If something fits, use it.
3. If something almost fits, extend it with a small change, as long as the result stays simple and cohesive: no flag parameters that switch between unrelated behaviors, no forced generalization.
4. Only when neither applies, write new code, in the right layer and in a file whose name describes it.

Never duplicate logic that already exists in the project.
