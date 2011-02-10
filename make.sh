#!/bin/bash

EXTRA_DEFS=$1

EXENAME=`echo $0 | awk -F"[/]" '{print $NF}'`
EXEDIR=`echo $0 | sed "s|${EXENAME}$||"`

if [ ! -f "${EXEDIR}/env" ]; then
    echo "File ${EXEDIR}/env not found! Please run ${EXEDIR}/setup.sh"
    exit 1
fi

source ${EXEDIR}/env

mkdir -p ${EXEDIR}/ebin

cat ${EXEDIR}/auto_gen/app.template | sed "s|%APP_NAME%|${APP_NAME}|g" | sed "s|%APP_DVER%|${APP_DVER}|g" | sed "s|%APP_MODULES%||g" > ${EXEDIR}/ebin/${APP_NAME}.app

cat ${EXEDIR}/auto_gen/Emakefile.template | sed "s|%EXTRA_DEF%|${EXTRA_DEFS}|g" > ${EXEDIR}/Emakefile

rm -fr ${EXEDIR}/make.sh.out

WD=`pwd`

cd ${EXEDIR}


$BINDIR/erl -noshell -make > make.sh.out

cd ${WD}

RES=`cat ${EXEDIR}/make.sh.out | grep -vE "Recompile:" | wc -l`

if [ ! ${RES} -eq 0 ]; then
    cat ${EXEDIR}/make.sh.out | grep -v "Recompile:" | sed "s|^|${EXEDIR}/|g" | sed "s|:| +|"
fi

#EOF
