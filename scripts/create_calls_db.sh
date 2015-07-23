#!/usr/bin/env bash
export LC_ALL=C
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`


if [ ! -f function-calls-db.txt ]
        then 
	echo "run $SCRIPTPATH/run_class_dumper.sh first"
	exit 1
fi

if [ ! -f function-statics-db.txt ]
        then
	echo "run $SCRIPTPATH/run_class_checker.sh first"
	exit 2
fi
$SCRIPTPATH/create_statics_esd_reports.sh
