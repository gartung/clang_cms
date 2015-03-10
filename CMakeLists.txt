# cmake -DLLVM_DIR=<LLVM_INSTALL_PREFIX> {/usr/local with default build of llvm}

cmake_minimum_required (VERSION 2.8.8)

project (clang_cms)

find_package(LLVM REQUIRED CONFIG)



include_directories( ${LLVM_INCLUDE_DIRS})

add_definitions(${LLVM_DEFINITIONS})

add_definitions(-std=c++11)

add_library( ClangCmsPlugin SHARED
ArgSizeChecker.cpp
CatchAll.cpp
ClangCmsCheckerPluginRegister.cpp
ClassChecker.cpp
ClassDumper.cpp
CmsException.cpp
CmsSupport.cpp
ConstCastAwayChecker.cpp
ConstCastChecker.cpp
edmChecker.cpp
FunctionChecker.cpp
FunctionDumper.cpp
getByChecker.cpp
getParamDumper.cpp
GlobalStaticChecker.cpp
MutableMemberChecker.cpp
StaticLocalChecker.cpp
ThrUnsafeFCallChecker.cpp
TrunCastChecker.cpp
UsingNamespace.cpp
)


target_link_libraries ( ClangCmsPlugin )
