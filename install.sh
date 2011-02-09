#!/bin/bash

#$Id:$

EXENAME=`echo $0 | awk -F"[/]" '{print $NF}'`
EXEDIR=`echo $0 | sed "s|${EXENAME}$||"`

if [ ! -f "${EXEDIR}/env" ]; then
    echo "File ${EXEDIR}/env not found! Please run ${EXEDIR}/env_setup.sh"
    exit 1
fi

source ${EXEDIR}/env

${EXEDIR}/build.sh

if [ -e "${EXEDIR}/${RELFILE}.tar.gz" ]; then

    TGT="${APP_NAME}-${APP_DVER}"

    cp ${EXEDIR}/${RELFILE}.tar.gz ${ROOTDIR}/releases/.

    if [ -e "${ROOTDIR}/releases/${RELFILE}.tar.gz" ]; then

        ${BINDIR}/erl -noshell -eval "{ok, _} = release_handler:start_link(), release_handler:remove_release(\"${TGT}\"), {ok, \"${TGT}\"} = release_handler:unpack_release(\"${RELFILE}\"), init:stop()."

    else
        echo "copy to ${ROOTDIR}/releases/${RELFILE}.tar.gz failed"
        exit 1
    fi

else

    echo "${EXEDIR}/${RELFILE}.tar.gz not found"
    exit 1

fi

#EOF
