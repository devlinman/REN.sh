#!/bin/bash

print_help() {
    echo "Syntax: REN [-h or --help]"
    echo "       REN [-l] [path/to/directory]"
    echo "       REN [-x path/to/directory]"
    echo "       REN [-xpdf path/to/directory]"
    echo "       REN [-xzip path/to/directory]"
    echo "       REN [path/to/directory]"
    echo ""
    echo "Options:"
    echo "  -h or --help: Show this help and exit."
    echo "  -l: Print 'file' for every file in the specified directory and exit."
    echo "  -x: Converts PNG and WEBP images in the specified directory into JPGs."
    echo "  -xpdf: Create PDFs from images in the specified directory using 'ex-pdf'."
    echo "  -xzip: Create a password-protected ZIP file from the specified directory."
    echo "  path/to/directory: Run on specified directory. Renames all files to their corresponding extensions."
    echo "Note:"
    echo "  - Only one path can be specified with or without the '-l' flag."
    echo "  - If no path is specified, the script runs on the present working directory."
    echo "  - This script is not recursive on sub-directories."
    echo "  - '-x' and '-xzip' are mutually exclusive!"
    echo "  - Issuing more than 1 argument (including '-x'/'-xzip') along with these will result in an error."
}

print_file_info() {
    local dir="$1"
    if [ -n "$dir" ]; then
        [ ! -d "$dir" ] && echo "Check file path: $dir" && exit 1
        echo "Found path: $dir"
        cd "$dir" || exit 1
    fi
    echo "Printing 'file' info"
    [ -z "$dir" ] && echo "in current directory." || echo "in '$dir'"
    for file in *; do
        echo "$(file -b --mime-type "$file")" "$file"
    done
}

convert_images() {
    local dir="$1"
    echo "'-x' option received!"
    [ -z "$dir" ] && dir="." # If no directory is provided, default to current directory
    local zipper_dir="$(basename "${dir}").zipper"
    mkdir -p "../${zipper_dir}" || exit 1
    find "$dir" -maxdepth 1 -type f -print0 | while IFS= read -r -d '' file; do
        if [[ $(file -b --mime-type "$file") == "image/webp" || $(file -b --mime-type "$file") == "image/png" ]]; then
            newname="$(basename "${file}" .${file##*.}).jpg"
            convert -verbose "$file" "../${zipper_dir}/${newname}"
        else
            cp -v "$file" "../${zipper_dir}/"
        fi
    done
    echo "Converted all image files in '$dir' and created folder '../${zipper_dir}'!"
}

create_pdf() {
    local dir="$1"
    echo "'-xpdf' option received!"
    [ -z "$dir" ] && dir="." # If no directory is provided, default to current directory
    [ -d "./PDF" ] && echo "PDF folder already exists. Aborting..." && exit 1
    ex-pdf "$dir" && rm -r "$dir" && echo "Created PDF file '../PDF/$(basename "$dir").pdf'" && echo "Removed $dir"
}

create_zip() {
    local dir="$1"
    [ -z "$dir" ] && dir="." # If no directory is provided, default to current directory
    convert_images "$dir"
    echo "'-xzip' option received!"
    local zipper_dir="$(basename "${dir}").zipper"
    local zipfile="${zipper_dir/zipper/zip}"
    cwd=$PWD && cd ..
    zip -re "$cwd/$zipfile" "${zipper_dir}" || exit 122
    rm -r "${zipper_dir}" || exit 1
    echo "Created $zipfile" && echo "Removed $zipper_dir"
    cd $cwd
}

rename_files() {
    local dir="${1:-.}"
    cd "$dir" || exit 1
    local count=0
    for file in *; do
        local filetype=$(file -b --mime-type "${file}") || exit 1
        case "$filetype" in
            image/webp) ext="webp" ;;
            image/png) ext="png" ;;
            image/jpeg) ext="jpg" ;;
            image/heic) ext="HEIC" ;;
            video/mp4) ext="mp4" ;;
            video/x-matroska) ext="mkv" ;;
            video/quicktime) ext="mov" ;;
            audio/mpeg) ext="mp3" ;;
            application/pdf) ext="pdf" ;;
            application/vnd.openxmlformats-officedocument.wordprocessingml.document) ext="docx" ;;
            *) continue ;;
        esac
        if [[ "${file##*.}" != "$ext" ]]; then
            newname="$(basename "${file}" .${file##*.}).$ext"
            mv -vn "${file}" "$newname" || {
                [ -f "$newname" ] && echo "Cannot rename, as a file '${newname}' already exists!"
                exit 1
            }
            ((count+=1))
        fi
    done
    echo "Task Finished Successfully! Total: '$count' files renamed of '$(ls | wc -l)' files!"
}

# Main script logic
case "$1" in
    -h|--help) print_help ;;
    -l) print_file_info "$2" ;;
    -x) convert_images "$2" ;;
    -xpdf) create_pdf "$2" ;;
    -xzip) create_zip "$2" ;;
    "") rename_files "$1" ;; # Run rename_files only when no valid flags are provided
    *) echo "Invalid option. Use '-h' or '--help' for usage information." ;;
esac
