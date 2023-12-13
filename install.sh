#!/usr/bin/env bash

mk()
{
    mkdir -p $1
}

symlink()
{
    f=$(readlink -e ${linkpath})

    if [ "$f" = "$filpath" ]
    then
        #echo "symlink ${fil} --> ${linkpath} already exists, skipping"
        return 0
    fi

    if [ -n "$f" ]
    then
        echo "error: file ${linkpath} already exists"
        return 1
    fi

    echo "symlinking ${filpath} to ${linkpath}"
    ln -s $filpath $linkpath
    return 0
}

if [ -n "$1" ]
then
    OUTDIR="$1"
else
    OUTDIR=$HOME
fi

cd "$(dirname "$0")"

FILES=$(cat manifest)

IFS=""
for fil in $FILES
do
    if [ "${fil:0:1}" = "#" ]
    then
        continue
    fi

    filpath="${PWD}/${fil}"
    linkdir="${OUTDIR}/$(dirname $fil)"
    linkpath="${OUTDIR}/${fil}"

    mk $linkdir
    symlink 
done
unset IFS

