#!/bin/bash

CWD=$(cd; pwd)
export GIT_ALLOW_PROTOCOL=hg
export PATH=$PATH:$PWD/bin


if [[ $# -eq 0 ]] || [[ $# -eq 1 ]]  ; then
    echo "$0 <directory of subrepo> <dst repo>"
    echo "Mirror repo and push"
    exit 0
fi

SUBMOD=$1
PUSH_REMOTE=$2

cd $SUBMOD
git fetch -p origin
git push --mirror
