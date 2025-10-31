#!/bin/sh
printf '\033c\033]0;%s\a' BugsBuzzy
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Gaol Creeper.x86_64" "$@"
