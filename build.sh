#!/bin/bash

#$Id:$

EXENAME=`echo $0 | awk -F"[/]" '{print $NF}'`
EXEDIR=`echo $0 | sed "s|${EXENAME}$||"`

if [ ! -f "${EXEDIR}/env" ]; then
    echo "File ${EXEDIR}/env not found! Please run ${EXEDIR}/env_setup.sh"
    exit 1
fi

source ${EXEDIR}/env


KERNEL_DVER=`ls ${ROOTDIR}/lib | grep -m 1 -E "^kernel" | sed 's/kernel-//g'`
STDLIB_DVER=`ls ${ROOTDIR}/lib | grep -m 1 -E "^stdlib" | sed 's/stdlib-//g'`

${EXEDIR}/clean.sh

${EXEDIR}/make.sh
RES=$?

if [ ! $RES -eq 0 ]; then
    echo "${EXEDIR}/make.sh failed"
    exit 1
fi


cat ${EXEDIR}/auto_gen/rel.template | sed "s|%APP_NAME%|${APP_NAME}|g" | sed  "s|%ERTS_DVER%|${ERTS_DVER}|g" | sed "s|%APP_VER%|${APP_VER}|g" | sed "s|%APP_DVER%|${APP_DVER}|g" | sed "s|%KERNEL_DVER%|${KERNEL_DVER}|g" | sed "s|%STDLIB_DVER%|${STDLIB_DVER}|g" > ${EXEDIR}/${RELFILE}.rel

if [ ! -e "${EXEDIR}/${RELFILE}.rel" ]; then
    echo "${EXEDIR}/${RELFILE}.rel not found"
    exit 1
fi

NUM_SRCS=`ls ${EXEDIR}/src/*.erl | wc -l`
NUM_BEAMS=`ls ${EXEDIR}/ebin/*.beam | wc -l`

TOTAL=$NUM_SRCS

if [ $TOTAL -eq $NUM_BEAMS ]; then

    MODS=`ls ${EXEDIR}/ebin | grep -E "[.]beam$" | sed "s|[.]beam|,|g"`

    MODS=`echo $MODS | sed "s|,$||g"`

    cat ${EXEDIR}/auto_gen/app.template | sed "s|%APP_NAME%|${APP_NAME}|g" | sed "s|%APP_DVER%|${APP_DVER}|g" | sed "s|%APP_MODULES%|${MODS}|g" > ${EXEDIR}/ebin/${APP_NAME}.app

    WD=`pwd`

    cd ${EXEDIR}

    $BINDIR/erl -noshell -pa ./ebin/ -s ibrowse_build_rel start "${RELFILE}"

    cd ${WD}

    if [ ! -e ${EXEDIR}/${RELFILE}.tar.gz ]; then

        echo "${EXEDIR}/${RELFILE}.tar.gz not found"
        exit 1

    fi

else
    echo "${EXEDIR}/build.sh failed"
    cat ${EXEDIR}/build.sh.out
    exit 1
fi

#EOF
