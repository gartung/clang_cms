#!/usr/bin/env bash
export LC_ALL=C
if [ $# -eq 0 ] ;then J=$(getconf _NPROCESSORS_ONLN); else J=$1; fi

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

export USER_LLVM_CHECKERS="-disable-checker cplusplus -disable-checker unix -disable-checker threadsafety -disable-checker core -disable-checker security -disable-checker deadcode -enable-checker optional.FunctionDumper -enable-checker optional.ClassDumper -enable-checker optional.ClassDumperCT -enable-checker optional.ClassDumperFT"

scan-build -load-plugin $SCRIPTPATH/../libclangSAplugin.so $USER_LLVM_CHECKERS make -k -j $J > /tmp/class+function-dumper.log 2>&1"
sort -u < /tmp/classes.txt.dumperct.unsorted | grep -e"^class" >classes.txt.dumperct.sorted
sort -u < /tmp/classes.txt.dumperct.unsorted | grep -v -e"^class" >classes.txt.dumperct.extra
awk -F\' ' {print "class \47"$2"\47\n\nclass \47"$4"\47\n\nclass \47"$6"\47\n\n" } '  <classes.txt.dumperct.sorted | sort -u >classes.txt.dumperct
sort -u < /tmp/classes.txt.dumperft.unsorted | grep -e"^class" >classes.txt.dumperft.sorted
sort -u < /tmp/classes.txt.dumperft.unsorted | grep -v -e"^class" >classes.txt.dumperft.extra
awk -F\' ' {print "class \47"$2"\47\n\nclass \47"$4"\47\n\nclass \47"$6"\47\n\n" } '  <classes.txt.dumperft.sorted | sort -u >classes.txt.dumperft
sort -u < /tmp/classes.txt.dumperall.unsorted | grep -e"^class" >classes.txt.dumperall
sort -u < /tmp/classes.txt.dumperall.unsorted | grep -v -e"^class" >classes.txt.dumperall.extra
sort -u < /tmp/function-dumper.txt.unsorted > function-calls-db.txt
$SCRIPTPATH/class-composition.py >classes.txt.inherits.unsorted
sort -u classes.txt.inherits.unsorted | grep -e"^class" | grep -v \'\' >classes.txt.inherits
sort -u classes.txt.inherits.unsorted | grep -v -e"^class" >classes.txt.inherits.extra
sort -u getparam-dumper.txt.unsorted | awk '{print $0"\n"}' >getparam-dumper.txt
cat classes.txt.inherits classes.txt.dumperft classes.txt.dumperct | grep -e"^class" | grep -v \'\' | sort -u >classes.txt
