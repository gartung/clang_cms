#!/usr/bin/env bash
export LC_ALL=C

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`



if [ ! -f function-calls-db.txt ]
	then
	echo "run $SCRIPTPATH/run_class_checker.sh first"
	exit 1
fi


if [ ! -f classes.txt.dumperft ]
        then
	echo "run $SCRIPTPATH/run_class_dumper.sh first"
	exit 2
fi

cat function-calls-db.txt function-statics-db.txt >db.txt 

$SCRIPTPATH/data-class-funcs.py 2>&1 > data-class-funcs-report.txt
grep -v -e "^In call stack " data-class-funcs-report.txt | grep -v -e"Flagged event setup data class"  >override-flagged-classes.txt
grep -e "^Flagged event setup data class" data-class-funcs-report.txt | sort -u | awk '{print $0"\n\n"}' >esd2tlf.txt
grep -e "^In call stack" data-class-funcs-report.txt | sort -u | awk '{print $0"\n\n"}' >tlf2esd.txt

$SCRIPTPATH/statics.py 2>&1 > statics-report.txt.unsorted
sort -u < statics-report.txt.unsorted > statics-report.txt
grep -e "^In call stack " statics-report.txt | awk '{print $0"\n"}' > modules2statics.txt
grep -e "^Non-const static variable " statics-report.txt | awk '{print $0"\n"}' > statics2modules.txt
