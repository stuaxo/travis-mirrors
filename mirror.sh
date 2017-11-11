#!/bin/bash

set -e 
CWD=$(cd; pwd)
export PATH=$PATH:$PWD/bin

if [[ $# -eq 0 ]] || [[ $# -eq 1 ]]  ; then
    echo "$0 <subrepo name> <dst repo url>"
    echo "Mirror repo and push"
    exit 0
fi


SUBMOD=$1
PUSH_REMOTE=$2

SUBMOD_URL=$(git config -f .gitmodules --get-regexp "^submodule\.${SUBMOD}\.url$" | cut -d' ' -f2)

SUBMOD_PATH=$(git config -f .gitmodules --get-regexp "^submodule\.${SUBMOD}\.path$" | cut -d' ' -f2)


# hg pull origins need GIT_ALLOW_PROTOCOL to be set
if [ $(echo $SUBMOD_URL | awk -F '::' '{print NF}') = 2 ]; then
    GIT_ALLOW_PROTOCOL=$(echo $SUBMOD_URL | awk -F '::' '{print $1}')
else
    unset GIT_ALLOW_PROTOCOL
fi 


CMD="git submodule update --init $SUBMOD"
if [ -n "${GIT_ALLOW_PROTOCOL}" ]; then
    GIT_ALLOW_PROTOCOL=$GIT_ALLOW_PROTOCOL $CMD
else
    $CMD
fi

cd $SUBMOD_PATH
git remote set-url --push origin $PUSH_REMOTE


CMD="git fetch -p origin"
if [ -n "${GIT_ALLOW_PROTOCOL}" ]; then
    GIT_ALLOW_PROTOCOL=$GIT_ALLOW_PROTOCOL $CMD
else
    $CMD
fi

echo "git push --mirror"
git push --mirror
