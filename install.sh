#!/usr/bin/env bash

mk()
{
    mkdir -p $1
}

if [ -n "$1" ]
then
    OUTDIR="$1"
else
    OUTDIR=$HOME
fi

cd "$(dirname "$0")"

FILES=$(cat manifest)

for fil in $FILES
do
    filpath="${PWD}/${fil}"
    linkdir="${OUTDIR}/$(dirname $fil)"
    linkpath="${OUTDIR}/${fil}"

    echo "symlinking ${filpath} to ${linkpath}"

    mk $linkdir
    ln -s $filpath $linkpath
done

