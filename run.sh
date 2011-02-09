#!/bin/bash

#$Id:$

EXENAME=`echo $0 | awk -F"[/]" '{print $NF}'`
EXEDIR=`echo $0 | sed "s|${EXENAME}$||"`

if [ ! -f "${EXEDIR}/env" ]; then
    echo "File ${EXEDIR}/env not found! Please run ${EXEDIR}/setup.sh"
    exit 1
fi

source ${EXEDIR}/env

cd ${EXEDIR}

if [ ! -e "Mnesia.ibrowse@$HOSTNAME" ]; then
    $BINDIR/erl -smp disable -pa ./ebin -sname ibrowse@${HOSTNAME} -s ibrowse_create_schema
fi

if [ -e "Mnesia.ibrowse@${HOSTNAME}" ]; then

    mkdir -p ${EXEDIR}/log

    $BINDIR/erl -smp disable -pa ./ebin -sname ibrowse@${HOSTNAME} -s ibrowse -config config/ibrowse

else

    echo "Could not create Mnesia schema in Mnesia.ibrowse@${HOSTNAME}"
    exit 1

fi

#EOF
