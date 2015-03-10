# cmake -DLLVM_DIR=<LLVM_INSTALL_PREFIX> {/usr/local with default build of llvm}

cmake_minimum_required (VERSION 2.8.8)

project (clang_cms)

find_package(LLVM REQUIRED CONFIG)
find_package(Clang REQUIRED CONFIG)

link_directories(${LLVM_LIB_DIR})

include_directories( ${LLVM_INCLUDE_DIRS})

add_definitions(${LLVM_DEFINITIONS})

add_definitions("-std=c++11")

add_library( ClangCmsPlugin SHARED
     src/ClangCmsCheckerPluginRegister.cpp
     src/CatchAll.cpp
     src/ClassChecker.cpp
     src/ClassDumper.cpp
     src/CmsSupport.cpp
     src/ConstCastAwayChecker.cpp
     src/ConstCastChecker.cpp
     src/FiniteMathChecker.cc
     src/FunctionChecker.cpp
     src/FunctionDumper.cpp
     src/GlobalStaticChecker.cpp
     src/MutableMemberChecker.cpp
     src/StaticLocalChecker.cpp
     src/TrunCastChecker.cpp
     src/UsingNamespace.cpp
     )


target_link_libraries ( ClangCmsPlugin 
${CLANG_LIBS} LLVMSupport )
