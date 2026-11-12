#!/usr/bin/env bash
# Installs the pinned toolchain, then applies the C++ Windows template to a
# project root that has no CMakeLists.txt yet.
#
# Usage: scaffold.sh <project root> <plugin root> <app name>   (paths as WSL paths)
# The app name becomes the CMake project and executable name: lower case
# letters, digits and underscores, starting with a letter.

set -euo pipefail

root=$(realpath "$1")
plugin=$(realpath "$2")
app_name=$3

if [ -e "$root/CMakeLists.txt" ]; then
	echo "scaffold: $root already has a CMakeLists.txt; nothing to scaffold" >&2
	exit 1
fi
if ! [[ $app_name =~ ^[a-z][a-z0-9_]*$ ]]; then
	echo "scaffold: invalid app name '$app_name': use lower case letters, digits and underscores" >&2
	exit 1
fi
case $app_name in
all | clean | help | install | package | test)
	echo "scaffold: '$app_name' is a target name CMake reserves; choose another" >&2
	exit 1
	;;
esac

# First, so a failed download leaves the project untouched and a rerun works.
bash "$plugin/template/scripts/project.sh" install-toolchain </dev/null

echo "scaffold: copying the template into $root"
cd "$plugin/template"
if [ -s "$root/.gitignore" ] && [ -n "$(tail -c1 "$root/.gitignore")" ]; then
	echo >>"$root/.gitignore"
fi
# Files the project already has (README, .gitignore, ...) are kept; .gitignore
# lines from the template are appended when missing.
while IFS= read -r -d '' file; do
	file=${file#./}
	if [ "$file" = .gitignore ] && [ -e "$root/.gitignore" ]; then
		while IFS= read -r line; do
			grep -qxF -- "$line" "$root/.gitignore" || printf '%s\n' "$line" >>"$root/.gitignore"
		done <.gitignore
	elif [ ! -e "$root/$file" ]; then
		mkdir -p "$(dirname "$root/$file")"
		cp "$file" "$root/$file"
	else
		echo "scaffold: kept the project's existing $file"
	fi
done < <(find . -type f -print0)

sed -i "s/@APP_NAME@/$app_name/" "$root/CMakeLists.txt"

echo "scaffold: done"
