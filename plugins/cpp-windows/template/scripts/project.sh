#!/usr/bin/env bash
# Single entry point for the project's toolchain and commands. Runs in WSL.
# Run it without arguments for the list of commands (see usage below).

set -euo pipefail

usage() {
	cat >&2 <<'EOF'
Usage: bash scripts/project.sh <command> [args...]
  install-toolchain   Download the pinned llvm-mingw and CMake (cmake/toolchain.env)
                      into $TOOLCHAINS_DIR (default ~/.local/opt), if missing.
  gates               Format check, then configure, build (warnings and clang-tidy
                      as errors) and test the debug preset.
  format              Format every C++ file in place with clang-format.
  build [preset]      Configure and build a preset (default: release).
  exec <cmd...>       Run any command with the pinned toolchain first on PATH.
EOF
}

project_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
# shellcheck source=../cmake/toolchain.env
source "$project_root/cmake/toolchain.env"
toolchains_dir=${TOOLCHAINS_DIR:-$HOME/.local/opt}
llvm_mingw_dir=$toolchains_dir/llvm-mingw-$LLVM_MINGW_VERSION
cmake_dir=$toolchains_dir/cmake-$CMAKE_VERSION

# Downloads an archive, checks its SHA-256 and unpacks it into <target dir>.
# The archive is unpacked next to the target and renamed into place, so an
# interrupted install never leaves a half-filled target.
install_archive() {
	local url=$1 sha256=$2 target=$3
	local tmp
	tmp=$(mktemp -d "$toolchains_dir/.install.XXXXXX")
	# shellcheck disable=SC2064 # expand $tmp now
	trap "rm -rf '$tmp'" EXIT
	echo "project: installing $(basename "$target")" >&2
	curl -fsSL -o "$tmp/archive" "$url"
	echo "$sha256  $tmp/archive" | sha256sum --check --quiet
	mkdir "$tmp/unpacked"
	tar -xf "$tmp/archive" -C "$tmp/unpacked" --strip-components=1
	rm -rf "$target"
	mv -T "$tmp/unpacked" "$target"
	rm -rf "$tmp"
	trap - EXIT
}

install_toolchain() {
	mkdir -p "$toolchains_dir"
	# One install at a time across worktrees and projects.
	exec 9>"$toolchains_dir/.install.lock"
	flock 9
	if [ ! -x "$llvm_mingw_dir/bin/clang++" ]; then
		install_archive \
			"https://github.com/mstorsjo/llvm-mingw/releases/download/$LLVM_MINGW_VERSION/llvm-mingw-$LLVM_MINGW_VERSION-ucrt-ubuntu-22.04-x86_64.tar.xz" \
			"$LLVM_MINGW_SHA256" "$llvm_mingw_dir"
	fi
	if [ ! -x "$cmake_dir/bin/cmake" ]; then
		install_archive \
			"https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION-linux-x86_64.tar.gz" \
			"$CMAKE_SHA256" "$cmake_dir"
	fi
	exec 9>&-
	if ! command -v ninja >/dev/null; then
		echo "project: ninja is missing; run: sudo apt install ninja-build" >&2
		exit 1
	fi
}

use_toolchain() {
	if [ ! -x "$llvm_mingw_dir/bin/clang++" ] || [ ! -x "$cmake_dir/bin/cmake" ]; then
		echo "project: toolchain missing; run: bash scripts/project.sh install-toolchain" >&2
		exit 1
	fi
	# Read by cmake/llvm-mingw-x86_64.cmake: this script is the only place that
	# knows where the toolchain lives.
	export LLVM_MINGW_ROOT=$llvm_mingw_dir
	export PATH=$cmake_dir/bin:$llvm_mingw_dir/bin:$PATH
	cd "$project_root"
}

cpp_files() {
	find src tests -type f \( -name '*.cpp' -o -name '*.hpp' \) -print0
}

command=${1:-}
shift || true
case $command in
install-toolchain)
	install_toolchain
	;;
gates)
	use_toolchain
	cpp_files | xargs -0 clang-format --dry-run --Werror
	cmake --workflow --preset debug
	;;
format)
	use_toolchain
	cpp_files | xargs -0 clang-format -i
	;;
build)
	use_toolchain
	cmake --workflow --preset "${1:-release}"
	;;
exec)
	use_toolchain
	exec "$@"
	;;
*)
	usage
	exit 2
	;;
esac
