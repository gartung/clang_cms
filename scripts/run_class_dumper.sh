#!/usr/bin/env bash
export LC_ALL=C 
if [ $# -eq 0 ] ;then J=$(getconf _NPROCESSORS_ONLN); else J=$1; fi
J=20
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
MODULEPATH=$SCRIPTPATH/../

paths=`echo $LD_LIBRARY_PATH | sed -e's/:/ /g'`

for p in $paths; do
    if [ -e ${p}/libclangSAplugin.so ]; then
        MODULEPATH=${p}
    fi
done
mrb z
mrbsetenv
buildtool -C -DCMAKE_C_COMPILER=`which ccc-analyzer` -DCMAKE_CXX_COMPILER=`which c++-analyzer`
USER_LLVM_CHECKERS="-disable-checker threadsafety -enable-checker optional.ClassDumper -enable-checker optional.FunctionDumper"
scan-build --use-cc=`which gcc` --use-c++=`which g++` --use-analyzer=`which clang` -load-plugin $MODULEPATH/libclangSAplugin.so $USER_LLVM_CHECKERS make VERBOSE=1 -k -j $J > /tmp/class+function-dumper.log 2>&1
sort -u < /tmp/classes.txt.dumperall.unsorted >classes.txt
sort -u < /tmp/function-dumper.txt.unsorted >function-db.txt
