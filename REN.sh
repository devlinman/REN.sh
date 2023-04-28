#! /bin/bash
[ "$#" -ge 3 ] && echo -e "\n\e[1;31mError: too many arguments\e[0m\nUse '-h' for help" && exit 100
OIFS="$IFS"
IFS=$'\n'

if [[ "$#" == "1" ]] && [[ "$1" =~ -x ]]; then
    echo -e "\n\e[1;32m'-x' option received!\e[0m\n"
    dir="$(basename "${PWD}").zipper"
    mkdir "../${dir}" || exit 200
    find * -maxdepth 1 -type f -print0 | while IFS= read -r -d '' file; do
        if [[ $(file -b --mime-type "$file") == "image/webp" || $(file -b --mime-type "$file") == "image/png" ]]; then
            newname=$(basename "${file}" ${file##*.})jpg
            convert -verbose "${file}" "../${dir}/${newname}"
        else
            cp -v "$file" "../${dir}/"
        fi
    done

    echo -e "\n\e[1;32mConveted all image files and created folder '../${dir}' !\e[0m\n"
    cd .. || exit 225
    [ -d ./PDF ] && echo -e "\e[1;31mPDF folder already exists.\nAborting...\e[0m" && exit 226
    [ "$1" == "-xpdf" ] && echo -e "\e[1;32m'-xpdf' option received!\e[0m" && ex-pdf "${dir}" && rm -r ${dir} && echo -e "\e[1;32m\nCreated PDF file ../PDF/${dir/zipper/pdf}\nRemoved $dir\e[0m"
    [ "$1" != "-xzip" ] && exit
    zipfile=${dir/zipper/zip}
    zip -re "$zipfile" "${dir}" || exit 250
    rm -r "${dir}" || exit 275
    echo -e "\e[1;32m\nCreated $zipfile\nRemoved $dir\e[0m"
    exit
fi

if [[ "$1" == "-l" ]]; then
    dir="$2"
    if [ -n "$dir" ]; then
        [ ! -d "$dir" ] && echo -e "\n\e[1;31mCheck file path:\e[0m $dir" && exit 300
        echo -e "\e[1;32mFound path: $dir\e[0m"
        cd "$dir" || exit 400
    fi
    echo -ne "\n\e[1;32m'-l' option recieved!\e[0m\nPrinting \`file\` info"
    [ -z $dir ] && echo -e " in current directory.\n" || echo -e " in '$dir'\n"

    for file in *
    do
        echo -e "\n\e[1;34m$(file -b --mime-type ${file})\e[0m\n\e[1;35m${file}\e[0m"
    done
    exit
fi

[[ "$@" == *-h* ]] || [[ "$@" == *--help* ]] && \
    echo -e "\nSyntax:\tREN ['-h' or '--help']\n\tREN ['-l'] ['path/to/directory']\n\tREN ['-x' or '-xzip' or '-xpdf']\n\tREN ['/path/to/directory']\n\nOptions:\n\n'-h' or '--help':\tShow this help and exit.\n\n'-l':\t\t\tPrint \`file\` for every file in the specified directory and exit.\n\n'-x'\t\t\tConverts all PNG and WEBP images in the current folder into JPGs and places them\n\t\t\tin a folder named '\${PWD}.zipper' (in the current folder) and exits.\n\n'-xpdf':\t\tThis option is useful to create pdfs from images in '\${PWD}.zipper' (using \`ex-pdf\`).\n\t\t\t(\$PWD=present working directory)\n\n\t\t\tAll JPGs and other files will be copied as they are into said folder.\n\n'-xzip':\t\tCreates a PASSWORD-PROTEDTED ZIP FILE from the folder mentioned above.\n\t\t\tThis option is an extension of the above option.\n\t\t\tAfter the zip file is ceated, the folder will be removed.\n\n'/path/to/directory':\tRuns on specified directory. Renames all files to their corresponding extensions.\n\t\t\tIf no path is specified, it runs on present working directory.\n\nNote:\n\t1. Only one path can be specified (along) with or without the '-l' flag.\n\n\t2. If no path is specified, the script runs on present working directory.\n\n\t3. This script is not recursive on sub-directories.\n\n\t4. '-x' and '-xzip are mutually exclusive!\n\t    Moreover, issuing more than 1 arguments (including '-x'/'-xzip') along with these will result in an error." && exit


[ -n "$1" ] && [ ! -d "$1" ] && echo -e "\n\e[1;31mIncorrect path!\e[0m\nUse '-h' for help" && exit 500
[ -z "$1" ] && dir="." || dir="$1"
[ "$dir" != "." ] && echo found directory "'$dir'" || echo -e "\e[1;32mWorking in current directory -\e[0m '$PWD'"
[ -d "$2" ] && echo -e found directory "'$2'\n\nToo many paths. Specify only one path." && exit 600
cd "$dir" || exit 700
[ -n "$1" ] && echo "changed to '$dir'"
count=0
for file in *; do
    filetype=$(file -b --mime-type "${file}") || (echo -e "\n\t\t\t\e[1;31mFAILURE!\e[0m\nPoint of failure:\t\e[1;31m\'$file\'\e[0m" && exit 1)
    case "$filetype" in
#           IMAGE FORMATS
        image/webp)
            ext="webp"
            ;;
        image/png)
            ext="png"
            ;;
        image/jpeg)
            ext="jpg"
            ;;
        image/heic)
            ext="HEIC"
            ;;
#           VIDEO FORMATS
        video/mp4)
            ext="mp4"
            ;;
        video/x-matroska)
            ext="mkv"
            ;;
        video/quicktime)
            ext="mov"
            ;;
#           AUDIO FORMATS
        audio/mpeg)
            ext="mp3"
            ;;
#           OFFICE DOCUMENT FORMATS
        application/pdf)
            ext="pdf"
            ;;
        application/vnd.openxmlformats-officedocument.wordprocessingml.document)
            ext="docx"
            ;;
        *)
            continue;
            ;;
    esac
    if [[ "${file##*.}" != "$ext" ]]; then
        newname="$(basename "${file}" .${file##*.} ).$ext"
        echo -e "\nOriginal File :\t\t\e[1;35m'${file}'\e[0m\nFile Type :\t\t\e[1;33m'${filetype}'\e[0m\nNew Name :\t\t\e[1;36m'${newname}'\e[0m\n"
        mv -vn "${file}" "$newname" || {
            [ -f "$newname" ] && echo -e "\n\t\e[1;31mCannot rename, as a file '${newname}' already exists!\e[0m"
            echo -e "\n\t\e[1;31mFailed to rename ${file}\e[0m\n\n\tTotal:\t$count files renamed!"
            exit 800
        }
        ((count+=1))
    fi
done
echo -e "\n\n\t\e[1;32mTask Finished Successfully!\n\tTotal:\t'\e[1;33m$count\e[0m' files renamed of '\e[1;35m$(ls | wc -l)\e[0m' files!\e[0m"
IFS="$OIFS"
echo EOF 1
exit


# @_devlinman
# CHAT_GPT
