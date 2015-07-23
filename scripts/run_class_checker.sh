#!/usr/bin/env bash
export LC_ALL=C 
if [ $# -eq 0 ] ;then J=$(getconf _NPROCESSORS_ONLN); else J=$1; fi
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
CLANG=`which clang`

MODULEPATH=$SCRIPTPATH/../

paths=`echo $LD_LIBRARY_PATH | sed -e's/:/ /g'`

for p in $paths; do
    if [ -e ${p}/libclangSAplugin.so ]; then
        MODULEPATH=${p}
    fi
done

export USER_LLVM_CHECKERS="-enable-checker threadsafety -enable-checker optional.ClassChecker -enable-checker optional.FunctionChecker"
scan-build --use-analyzer=${CLANG} -load-plugin $MODULEPATH/libclangSAplugin.so $USER_LLVM_CHECKERS make -k -j $J > /tmp/class+function-checker.log 2>&1
sort -u < /tmp/class-checker.txt.unsorted | grep -e"^data class">class-checker.txt
sort -u < /tmp/function-checker.txt.unsorted >function-statics-db.txt
