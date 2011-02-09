#!/bin/bash

#$Id:$

EXENAME=`echo $0 | awk -F"[/]" '{print $NF}'`
EXEDIR=`echo $0 | sed "s|${EXENAME}$||"`

AVAIL_ERTS=`ls /home/erlang/lib`

ERTS=$1

if [ -z "${ERTS}" ]; then

    echo "The following ERTS installations were found"
    echo "    ${AVAIL_ERTS}"
    echo ""
    read -p "Please select the ERTS you want to build for: " ERTS

fi

ERTS=`echo "${ERTS}" | awk '{print $1}'`

if [ -z "${ERTS}" ]; then
    echo "aborted"
    exit 1
fi


ENV=${EXEDIR}/env

FOUND=`echo "${AVAIL_ERTS}" | grep -E "^${ERTS}$"`

if [ -z "${FOUND}" ]; then

    echo "erts ${ERTS} not found"

    exit 1 

else

    APP_NAME=`cat ${EXEDIR}/auto_gen/app_name`

    ERTS_DIR=`ls /home/erlang/lib/${ERTS}/lib/erlang/ | grep "erts"`
    ERTS_DVER=`echo ${ERTS_DIR} | sed 's/erts-//g'`
    ERTS_VER=`echo ${ERTS_DIR} | sed 's/erts-//g' | awk -F"[.]" '{print $1$2$3}'`
    
    ROOTDIR=/home/erlang/lib/${ERTS}/lib/erlang
    RELDIR=${ROOTDIR}/releases

    RELFILE=${APP_NAME}_${APP_VER}_erts_${ERTS_VER}

    echo "#!/bin/bash" > ${ENV}
    echo "HOSTNAME=\`hostname -s\`" >> ${ENV}
    echo "I_AM=\`whoami\`" >> ${ENV}
    echo "APP_NAME=${APP_NAME}" >> ${ENV}
    echo "ERTS_DVER=${ERTS_DVER}" >> ${ENV}
    echo "ERTS_VER=${ERTS_VER}" >> ${ENV}
    echo "ROOTDIR=${ROOTDIR}" >> ${ENV}
    echo "BINDIR=\$ROOTDIR/${ERTS_DIR}/bin" >> ${ENV}
    echo "EMU=beam" >> ${ENV}
    echo "PROGNAME=\`echo \$0 | sed 's/.*\///'\`" >> ${ENV}

    WD=`pwd`

    cd ${EXEDIR}
    ABSEXEDIR=`pwd`

    cd ${WD}

    echo "APP_DVER=\`cat ${ABSEXEDIR}/auto_gen/version\`" >> ${ENV}

    echo 'APP_VER=`echo "${APP_DVER}" | sed "s|[.]||g"`' >> ${ENV}
    echo 'RELFILE=${APP_NAME}_${APP_VER}_erts_${ERTS_VER}' >> ${ENV}

    echo "export HOSTNAME" >> ${ENV}
    echo "export I_AM" >> ${ENV}
    echo "export APP_NAME" >> ${ENV}
    echo "export ERTS_DVER" >> ${ENV}
    echo "export ERTS_VER" >> ${ENV}
    echo "export EMU" >> ${ENV}
    echo "export ROOTDIR" >> ${ENV}
    echo "export BINDIR" >> ${ENV}
    echo "export PROGNAME" >> ${ENV}
    echo "export APP_VER" >> ${ENV}
    echo "export APP_DVER" >> ${ENV}
    echo "export RELFILE" >> ${ENV}

    echo "#EOF" >> ${ENV}

    chmod +x ${ENV}

fi

#EOF
