
add_clang_library( clangSAplugin
  CatchAll.cpp
  ClangCmsCheckerPluginRegister.cpp
  ClassChecker.cpp
  ClassDumper.cpp
  CmsSupport.cpp
  ConstCastAwayChecker.cpp
  ConstCastChecker.cpp
  FiniteMathChecker.cc
  FunctionChecker.cpp
  FunctionDumper.cpp
  GlobalStaticChecker.cpp
  MutableMemberChecker.cpp
  StaticLocalChecker.cpp
  TrunCastChecker.cpp
  UsingNamespace.cpp

  DEPENDS
  ClangSACheckers

  LINK_LIBS
  clangAST
  clangASTMatchers
  clangBasic
  clangFrontend
  clangRewrite
  clangSema
  clangStaticAnalyzerCore
  clangStaticAnalyzerFrontend
  clangTooling
  clangToolingCore
  )

