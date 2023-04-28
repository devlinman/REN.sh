#! /bin/bash
[ ! -d "./PDF" ] && mkdir "./PDF" || exit 1
OIFS="$IFS"
IFS=$'\n'

function converter() {
    local dir="$1"
    local type="$2"
    echo working in $dir
    if [[ "$type" == "JPEG" ]]; then
        find $dir -name '*.jp*' -print0 | sort -z -V | xargs -0r img2pdf -s 1080x2400 --rotation=ifvalid --fit into -o "./PDF/$(basename $dir)".pdf;
    elif [[ "$type" == "PNG" ]]; then
        find $dir -name '*.png' -print0 | sort -z -V | xargs -0r img2pdf -s 1080x2400 --rotation=ifvalid --fit into -o "./PDF/$(basename $dir)".pdf;
    else
        echo -e "Somefn's gone horribly wrong! Fuck this!"
        exit 1
    fi
}

if [[ "$#" == 0 ]] || [[ "$@" == *~F* ]]; then
    [ "$#" -gt 1 ] && echo "do not use other options with 'F'" &&  exit 1
    for dir in $(find * -maxdepth 0 -type d); do
        count_JP=$(find "$dir" -maxdepth 1 -name '*.jp*' -type f -printf '.' | wc -c)
        count_PNG=$(find "$dir" -maxdepth 1 -name '*.png' -type f -printf '.' | wc -c)
        echo -e "No. of JPG/JPEG files\t$count_JP\nNo. of PNG files\t$count_PNG\n"
        if [[ $count_JP != 0 && $count_PNG != 0 ]]; then
            ( echo -e "\nSomething is wrong!!!\nCheck $dir\nJPG=$count_JP\tPNG=$count_PNG\nno. of sub-directories in $dir=$(find $dir/* -maxdepth 0 -type d | wc -l)\nDiagnosis:\tBOTH JPG and PNG files exist in \" $dir \"" && break )
        elif [[ $count_JP != 0 && $count_PNG == 0 ]]; then
            converter "$dir" "JPEG"
        elif [[ $count_PNG != 0 && $count_JP == 0 ]]; then
            converter "$dir" "PNG"
        else
            echo -e "The directory \" $dir \" is empty!\nYou may need to check the name of directory.\nPaths with '[]' are not allowed.\n"
            [[ "$@" == *~F* ]] && echo -e "\nLoop override set! Proceeding to next directory!" && continue
            echo set '$1'=~F to Override Loop! && break
        fi
    done
    exit
fi
[ "$#" -gt 2 ] && echo too many arguments && exit 1
[ "$1" == "." ] && dir=${PWD} || dir="$1"
if [ -d "$dir" ]; then
    echo -e "\e[1;34mfound path\e[0m $dir"
    if [[ $(find "$dir" -type f -name "*.jpg" | wc -l) -eq $(find "$dir" -type f | wc -l) ]]; then
        echo jpeg files found
        converter "$dir" "JPEG"
        echo -e "\nJPG/JPEG:$(find "$dir" -name "*.jpg" -type f | wc -l)\tDIR = $dir \t Completed"
    elif [[ $(find "$dir" -type f -name "*.png" | wc -l) -eq $(find "$dir" -type f | wc -l) ]]; then
        echo png files found
        converter "$dir" "PNG"
        echo -e "\nPNG:$(find "$dir" -name "*.png" -type f | wc -l)\tDIR = $dir \t Completed"
    else
        echo -e "\nother files found in current directory!\n\nCannot proceed!\nConvert all the images to PNG or JPG first or use -both flag!\n"
        exit 1
    fi
    echo EOF 1 && exit
fi

IFS="$OIFS"
echo EOF 2; exit
