
add_clang_library( clangSAplugin
  ArgSizeChecker.cpp
  CatchAll.cpp
  ClangCmsCheckerPluginRegister.cpp
  ClassChecker.cpp
  ClassDumper.cpp
  CmsSupport.cpp
  ConstCastAwayChecker.cpp
  ConstCastChecker.cpp
  EDMPluginDumper.cc
  FiniteMathChecker.cc
  FunctionChecker.cpp
  FunctionDumper.cpp
  GlobalStaticChecker.cpp
  MutableMemberChecker.cpp
  StaticLocalChecker.cpp
  ThrUnsafeFCallChecker.cpp
  TrunCastChecker.cpp
  UsingNamespace.cpp
  edmChecker.cpp
  getByChecker.cpp
  getParamDumper.cpp

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

