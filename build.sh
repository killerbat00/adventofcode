#!/usr/bin/env bash

magenta='\e[1;35m'
red='\e[1;31m'
white='\e[0;37m'

shopt -s extglob

if [[ $EUID -eq 0 ]]; then
    echo "no root, pls."
    exit 1
fi

SRC_FILE=main.nim
OUTPUT_DIR=bin
RLS_OUTPUT_FILE="${OUTPUT_DIR}"/aoc.2022
DEV_OUTPUT_FILE="${RLS_OUTPUT_FILE}"-DEV

PRE_BUILD_HOOKS=hooks.sh

dry_run() {
    local MODE=$1
    local RUN=$2
    if [[ "${MODE,,}" == "dev" ]]; then
        echo "rm -rf ${OUTPUT_DIR}"
        if [ -f $PRE_BUILD_HOOKS ]; then
            echo "./$PRE_BUILD_HOOKS"
        fi
        echo "nim c -o:${DEV_OUTPUT_FILE} ${RUN} ${SRC_FILE}"
    elif [[ "${MODE,,}" == "rls" ]]; then
        echo "rm -rf ${OUTPUT_DIR}"
        if [ -f $PRE_BUILD_HOOKS ]; then
            echo "./$PRE_BUILD_HOOKS"
        fi
        echo "nim c -o:${RLS_OUTPUT_FILE} -d:release --opt:speed ${RUN} ${SRC_FILE}"
    else
        echo -e "$red Include one of {dev|rls} $white"
        usage
        exit 1
    fi
}

wet_run() {
    local MODE=$1
    local RUN=$2
    if [[ "${MODE,,}" == "dev" ]]; then
        rm -rf $OUTPUT_DIR
        if [ -f $PRE_BUILD_HOOKS ]; then
            ./$PRE_BUILD_HOOKS
        fi
        nim c -o:$DEV_OUTPUT_FILE $RUN $SRC_FILE
    elif [[ "${MODE,,}" == "rls" ]]; then
        rm -rf $OUTPUT_DIR
        if [ -f $PRE_BUILD_HOOKS ]; then
            ./$PRE_BUILD_HOOKS
        fi
        nim c -o:$RLS_OUTPUT_FILE -d:release --opt:speed $RUN $SRC_FILE
    else
        echo -e "$red Include one of {dev|rls} $white"
        usage
        exit 1
    fi
}

usage() {
    local program_name
    program_name=${0##*/}
    cat <<EOF
Usage: $program_name [-t] {dev|rls} [-r]
Options:
    -t      dry run, echos commands without executing
    dev     build development version
    rls     build release version
    -r      run after building
EOF
}

main() {
    case "$1" in
        ''|-h|--help)
            usage
            exit 0
            ;;
        -t)
            dry_run $2 $3
            exit 0
            ;;
        dev|rls|DEV|RLS)
            wet_run $1 $2
            exit 0
            ;;
        *)
            echo -e "$red computer says no $white"
            usage
            exit 1
            ;;
    esac

}

main "$@"
