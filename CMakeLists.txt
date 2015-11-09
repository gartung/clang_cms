cmake_minimum_required (VERSION 2.8.8)

project (clangSAplugin CXX)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules)

find_package(LLVM REQUIRED)

link_directories(${LLVM_LIB_DIR})

find_package(Clang REQUIRED)

include_directories( ${CLANG_INCLUDE_DIRS} )

add_definitions("-std=c++11")

add_definitions (-D__STDC_LIMIT_MACROS -D__STDC_CONSTANT_MACROS)
add_definitions (-D_GNU_SOURCE -DHAVE_CLANG_CONFIG_H)

# omit reports for some CMS specific cases
add_definitions ( -DTHREAD_CHECKS_USE_CMS_EXCPEPTIONS )

# omit reports found in the system headers
add_definitions ( -DTHREAD_CHECKS_NO_REPORT_SYSTEM )

set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-common -Woverloaded-virtual -Wcast-qual -fno-strict-aliasing -pedantic -Wno-long-long -Wall -W -Wno-unused-parameter -Wwrite-strings -fno-exceptions -fno-rtti")

set (CMAKE_MODULE_LINKER_FLAGS "-Wl,-flat_namespace -Wl,-undefined -Wl,suppress")

add_library( clangSAplugin SHARED
     src/CatchAll.cpp
     src/ClangCmsCheckerPluginRegister.cpp
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

target_link_libraries ( clangSAplugin )
