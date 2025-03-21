#!/usr/bin/env bash

usage()
{
    printf "Usage: $(basename $0) [options] [install path]\n"
    printf "Options:\n"
    printf "    %-20s Print help and exit.\n" "-h, --help"
    printf "    %-20s Verbose output.\n" "-v, --verbose"
    printf "    %-20s Force rewrite existing files when symlinking.\n" "-f, --force"
    printf "    %-20s Copy instead of symlinking.\n" "-c, --copy"
    printf "    %-20s Use fixes for MSYS2 (untested).\n" "    --msys"
    printf "    %-20s Do not do anything (dry run).\n" "    --dry"
}

mk()
{
    mkdir -p $1
}

symlink()
{
    f=$(readlink -e ${linkpath})

    if [ "$f" = "$filpath" ] && [ $FORCE = 0 ]
    then
        if [ $VERBOSE = 1 ]
        then
            echo "symlink ${fil} --> ${linkpath} already exists, skipping"
        fi
        return 0
    fi

    if [ -n "$f" ]
    then
        if [ $FORCE = 0 ]
        then
            echo "error: file ${linkpath} already exists"
            return 1
        fi
        if [ $DRY = 0 ]; then rm -f ${linkpath}; fi
    fi

    if [ $COPY = 1 ]
    then
        printf "copying "
        if [ $DRY = 0 ]; then cp $filpath $linkpath; fi
    elif [ $MSYS = 1 ]
    then
        printf "mklinking "
        if [ $DRY = 0 ]; then cmd //c "mklink $filpath $linkpath"; fi
    else
        printf "symlinking "
        if [ $DRY = 0 ]; then ln -s $filpath $linkpath; fi
    fi

    printf "${filpath} to ${linkpath}\n"

    return 0
}

VERBOSE=0
FORCE=0
COPY=0
MSYS=0
DRY=0

# store positional arguments in a temporary array
ARGS=()

while [[ $# -gt 0 ]]
do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=$(( $VERBOSE + 1 ))
            shift
            ;;
        -f|--force)
            FORCE=1
            shift
            ;;
        -c|--copy)
            COPY=1
            shift
            ;;
        --msys)
            MSYS=1
            shift
            ;;
        --dry)
            DRY=1
            shift
            ;;
        -*|--*)
            printf "Unknown option \"$1\"."
            exit 1
            ;;
        *)
            ARGS+=("$1")
            shift
            ;;
    esac
done

# move positional arguments from ARGS to argv
set -- "${ARGS[@]}"

if [ -n "$1" ]
then
    OUTDIR="$1"
else
    OUTDIR=$HOME
fi

# ensure that the current working directory is the dotfiles directory
cd "$(dirname "$0")"

FILES=$(cat manifest)

IFS=$'\n'
for fil in $FILES
do
    if [ $VERBOSE = 2 ]
    then
        printf "processing fil: %s\n" "$fil"
    fi
    if [ "${fil:0:1}" = "#" ]
    then
        if [ $VERBOSE = 2 ]
        then
            printf "fil is a comment, skipping\n"
        fi
        continue
    fi

    filpath="${PWD}/${fil}"
    linkdir="${OUTDIR}/$(dirname $fil)"
    linkpath="${OUTDIR}/${fil}"

    mk $linkdir
    symlink
done
unset IFS

