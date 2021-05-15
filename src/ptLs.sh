#!/usr/bin/env bash

source ~/DevLib/ptSh/config
test -f ~/DevLib/ptsh/.config/ptSh/config && source ~/DevLib/ptsh/.config/ptSh/config

columnSize=0
IFS=' '

function getColumnSize(){
    while read -r line; do
        if ((${#line} > columnSize)); then
            columnSize=${#line}
        fi
    done <<<$(ls -Q$arg 2>/dev/null)
}

function setArgs(){
    if [[ $1 != "-"* ]] || [[ $1 == "-l" ]]; then
        arg=""
        return 0
    fi
    if [[ $1 == *"a"* ]]; then
        arg="${arg}a"
    fi
    if [[ $1 == *"A"* ]]; then
        arg="${arg}A"
    fi
}

function align(){
    for (( i=0; i<$((columnSize-(actualChar%columnSize))); i++ )); do
        echo -n " "
    done
}

arg=""
setArgs $1

if [[ ! -z $arg ]];
    then a=$arg
fi

LS="$(ls -l$arg | sort -k1 -r)"

getColumnSize

columnSize=$((columnSize+LS_MIN_FILE_OFFSET))

if ((${#DIR_PREFIX} > ${#FILE_PREFIX})); then
    columnSize=$((columnSize+${#DIR_PREFIX}))
else
    columnSize=$((columnSize+${#FILE_PREFIX}))
fi

columns=$(($(tput cols) / columnSize))
i=0
actualChar=0
actualColumn=0


while read -r line; do
    # Break the line into individual words
    read -a words <<< $line

    # ignore the first line: just contains a count
    declare -i wc=$(echo $line | wc -w)
    if [[ $wc == 2 ]]; then continue; fi

    link=false

    # determin if file, folder, or link
    if [[ ${words[0]:0:1} == "d"* ]]; then
        filename="${DIR_PREFIX_ESCAPE_CODES}${DIR_PREFIX}\x1B[0m${DIR_NAME_ESCAPE_CODES}"
        prefixLength=${#DIR_PREFIX}
    elif [[ ${words[0]} == "l"* ]];then
        filename="${LINK_PREFIX_ESCAPE_CODES}${LINK_PREFIX}\x1B[0m${LINK_NAME_ESCAPE_CODES}"
        prefixLength=${#LINK_PREFIX}
        link=true
    else
        filename="${FILE_PREFIX_ESCAPE_CODES}${FILE_PREFIX}\x1B[0m${FILE_NAME_ESCAPE_CODES}"
        prefixLength=${#FILE_PREFIX}
    fi


    # Isolate the filename and length
    nameLength=$((${#words[@]:8}))
    filename="$filename ${words[@]:8}"

    # close the colour sandwhich
    filename="$filename\x1B[0m"
    
    actualChar=$((nameLength+prefixLength))
    
    if [[ $1 == *"l"* ]]; then
        echo -ne $filename
        align
        echo -n "${words[0]} ${words[2]} ${words[3]}"

        if $link; then
            echo " -> ${words[7]:1:-1}"
        else
            echo
        fi
    else
        echo -ne $filename
        align
        actualChar=$((actualChar+(columnSize-(actualChar%columnSize))))
        actualColumn=$((actualColumn+1))
        if (($actualColumn >= $columns)); then
            echo
            actualColumn=0
            actualChar=0
        fi
    fi

done <<<$(echo "$LS")
echo
