---
name: setup
description: Install or update the C++ Windows rules, and scaffold the CMake app when the project has none yet.
disable-model-invocation: true
argument-hint: "[app_name]"
---

Set up the C++ Windows stack in the current project. `<root>` is `${CLAUDE_PROJECT_DIR}`, which must be the main checkout on `master`, not a worktree. Run every command in WSL as the environment rules describe; installing the toolchain downloads about 140 MB, so run the scaffold in the background.

1. Check that `<root>/.claude/rules/coding-base-windows/` and `<root>/.claude/rules/gitflow/` exist. If one is missing, stop and tell the user to run `/coding-base-windows:setup` and `/gitflow:setup` first.
2. Copy every file in `${CLAUDE_PLUGIN_ROOT}/rules/` to `<root>/.claude/rules/cpp-windows/`, replacing files with the same name. Do not touch any other folder under `.claude/rules/`. If `.claude/rules/cpp-windows/` holds files that are no longer in the plugin, list them and ask the user before removing them.
3. Check the tools in WSL: `curl`, `tar`, `xz` and `ninja` must be on `PATH`. If one is missing, ask the user to run `sudo apt install curl xz-utils ninja-build`. Check that WSL can start Windows programs: `cmd.exe /c ver` must print the Windows version; if it fails, tell the user to enable WSL interop (`[interop] enabled=true` in `/etc/wsl.conf`), because the tests run as Windows executables.
4. If `<root>/CMakeLists.txt` does not exist, scaffold the app. The app name is `$ARGUMENTS` if given, otherwise the project folder's name; convert it to lower case with underscores (`My-Tool` becomes `my_tool`) and confirm it with the user. Then run:
   `bash "<plugin root as a WSL path>/setup/scaffold.sh" "<root as a WSL path>" "<plugin root as a WSL path>" <app_name>`
   The script copies the template in `${CLAUDE_PLUGIN_ROOT}/template/` (CMake project and presets, toolchain file and pinned versions, dependencies, clang-format and clang-tidy configuration, a layered example app with tests, the UTF-8 manifest, `scripts/project.sh`), keeps files the project already has, merges `.gitignore`, sets the app name and installs the pinned toolchain.
   If `CMakeLists.txt` exists, do not scaffold: compare the project with the template and report what differs (toolchain file, pinned versions, presets, `scripts/project.sh`, static linking, clang-tidy, dependencies outside `cmake/dependencies.cmake`), without changing it.
5. Run the quality gates in `<root>` on an ext4 copy, as the quality-gate rules and `rules/stack.md` describe. Report any failure to the user.
6. Report what was created. Tell the user to commit everything directly on `master` (the workflow is not active for this first commit), to start a new session, and that `bash scripts/project.sh build` produces the self-contained `build/release/<app_name>.exe`.
