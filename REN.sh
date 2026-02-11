#! /usr/bin/env bash
set -e Eueo pipefail

print_help() {
    echo "Syntax: REN [-h or --help]"
    echo "        REN [-l] [path/to/directory]"
    echo "        REN [path/to/directory]"
    echo ""
    echo "Options:"
    echo "  -h or --help: Show this help and exit."
    echo "  -l: Print 'file' for every file in the specified directory and exit."
    echo "  path/to/directory: Run on specified directory. Renames all files to their corresponding extensions."
    echo "Note:"
    echo "  - Only one path can be specified with or without the '-l' flag."
    echo "  - If no path is specified, the script runs on the present working directory."
    echo "  - This script is not recursive on sub-directories."
    echo "  - This script also ignores hidden files and folders completely."
}

map_ext() {
    case "$1" in
    image/gif) echo "gif" ;;
    image/webp) echo "webp" ;;
    image/png) echo "png" ;;
    image/jpeg) echo "jpg" ;;
    image/heic) echo "HEIC" ;;
    video/mp4) echo "mp4" ;;
    video/x-matroska) echo "mkv" ;;
    video/quicktime) echo "mov" ;;
    audio/mpeg) echo "mp3" ;;
    application/pdf) echo "pdf" ;;
    application/zip) echo "zip" ;;
    *) echo "" ;;
    esac
}

print_file_info() {
    local dir="${1:-.}"

    [ ! -d "$dir" ] && echo "Check path: $dir" && return 1

    cd "$dir" || return 1
    GREEN=$'\e[32;1m'
    RED=$'\e[31;1m'
    YELLOW=$'\e[33;1m'
    RESET=$'\e[0m'

    for file in *; do
        [ -f "$file" ] || continue

        local mimetype
        mimetype=$(file -b --mime-type -- "$file") || return 1

        local expected_ext
        expected_ext=$(map_ext "$mimetype")

        local current_ext=""
        [[ "$file" == *.* ]] && current_ext="${file##*.}"

        local mark="${YELLOW}?${RESET}"

        if [ -n "$expected_ext" ]; then
            if [ -n "$current_ext" ] && [[ "${current_ext,,}" == "${expected_ext,,}" ]]; then
                mark="${GREEN}✔${RESET}"
            else
                mark="${RED}✘${RESET}"
            fi
        fi

        printf "%b %-60s %s\n" "$mark" "$mimetype" "$file"
    done
}

rename_files() {
    local dir="${1:-.}"

    [ ! -d "$dir" ] && echo "Check file path: $dir" && return 1

    cd "$dir" || return 1

    local count=0
    local total=0

    for file in *; do
        [ -f "$file" ] || continue
        ((total++))

        local mimetype
        mimetype=$(file -b --mime-type -- "$file") || return 1

        local expected_ext
        expected_ext=$(map_ext "$mimetype")

        [ -z "$expected_ext" ] && continue

        local current_ext=""
        local base="$file"

        if [[ "$file" == *.* ]]; then
            current_ext="${file##*.}"
            base="${file%.*}"
        fi

        if [[ "${current_ext,,}" != "${expected_ext,,}" ]]; then
            local newname="${base}.${expected_ext}"

            if [ -e "$newname" ]; then
                echo "Cannot rename '$file' -> '$newname' (target exists)"
                return 1
            fi

            mv -iv -- "$file" "$newname" || return 1
            ((count++))
        fi
    done

    echo "Task finished. Renamed $count of $total files."
}

# Main script logic
case "$1" in
-h | --help) print_help ;;
-l) print_file_info "$2" ;;
"") rename_files "$1" ;; # Run rename_files only when no valid flags are provided
*) echo "Invalid option. Use '-h' or '--help' for usage information." ;;
esac
