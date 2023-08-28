#!/usr/bin/env bash

mk()
{
    mkdir -p $1
}

mkcd()
{
    mk $1 && cd $1
}

FILES=$(cat manifest)

if [ -n "$1" ]
then
    OUTDIR="$1"
else
    OUTDIR=$HOME
fi

for fil in $FILES
do
    filpath="${PWD}/${fil}"
    linkdir="${OUTDIR}/$(dirname $fil)"
    linkpath="${OUTDIR}/${fil}"

    echo "symlinking ${filpath} to ${linkpath}"

    mk $linkdir
    ln -s $filpath $linkpath
done

