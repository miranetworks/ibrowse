#!/bin/bash

START_DIR=`pwd`

BUILD_DIR=`echo $0 | sed "s|/test.sh||"`

cd ${BUILD_DIR}

BUILD_DIR=`pwd`

source ./env

./clean.sh

./make.sh "{d, 'TEST'},"
RES=$?

if [ ! $RES -eq 0 ]; then
    echo "${BUILD_DIR}/make.sh failed"
    cd ${START_DIR}
    exit 1
fi

rm -fr "${BUILD_DIR}/test.sh.out"

RUN_SPEC=`ls ebin/ | grep -vE ".app$" | sed 's|.beam$||g' | while read mod; do echo -n "io:format(\"Testing ~p~n~n\", ['$mod']), eunit:test($mod), io:format(\"~n~n~n\",[]), "; done; echo -n "init:stop()."`

$BINDIR/erl -noshell -pa ./ebin -eval "${RUN_SPEC}"

cd ${START_DIR}

#EOF
