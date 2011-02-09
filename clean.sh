#!/bin/bash

EXENAME=`echo $0 | awk -F"[/]" '{print $NF}'`
EXEDIR=`echo $0 | sed "s|${EXENAME}$||"`

rm -fr ${EXEDIR}/Emakefile
rm -fr ${EXEDIR}/erl_crash.dump
rm -fr ${EXEDIR}/*.rel
rm -fr ${EXEDIR}/ebin/*.beam
rm -fr ${EXEDIR}/ebin/*.app
rm -fr ${EXEDIR}/*access*
rm -fr ${EXEDIR}/*.log
rm -fr ${EXEDIR}/*.tar.gz
rm -fr ${EXEDIR}/*.script
rm -fr ${EXEDIR}/*.boot
rm -fr ${EXEDIR}/*.out

#EOF
