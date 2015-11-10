//===--- CmsSupport.cpp - Provides support functions ------------*- C++ -*-===//
//
// by Shahzad Malik MUZAFFAR [ Shahzad.Malik.MUZAFFAR@cern.ch ]
//
//===----------------------------------------------------------------------===//
#include "CmsSupport.h"
#include <clang/Basic/FileManager.h>
#include <clang/StaticAnalyzer/Core/Checker.h>
#include <clang/StaticAnalyzer/Core/PathSensitive/CheckerContext.h>
#include <clang/StaticAnalyzer/Core/BugReporter/BugType.h>
#include <llvm/ADT/SmallString.h>
#include <clang/AST/DeclTemplate.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Support/Regex.h>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <fstream>
#include <iterator>
#include <string>

using namespace clangcms;
using namespace clang;
using namespace llvm;


// This is a wrapper around NamedDecl::getQualifiedNameAsString.
// It produces more qualified output to distinguish several cases
// which would otherwise be ambiguous.
std::string support::getQualifiedName(const clang::NamedDecl &d) {
  std::string ret;
  const DeclContext *ctx = d.getDeclContext();
  if (ctx->isFunctionOrMethod() && isa<NamedDecl>(ctx))
  {
    // This is a local variable.
    // d.getQualifiedNameAsString() will return the unqualifed name for this
    // but we want an actual qualified name so we can distinguish variables
    // with the same name but that are in different functions.
    ret = getQualifiedName(*cast<NamedDecl>(ctx)) + "::" + d.getNameAsString();
  }
  else
  {
    ret = d.getQualifiedNameAsString();
  }

  if (const FunctionDecl *fd = dyn_cast_or_null<FunctionDecl>(&d))
  {
    if (fd->isFunctionTemplateSpecialization())
    {
      ret += "<";
      const TemplateArgumentList *TemplateArgs = fd->getTemplateSpecializationArgs();
      if (TemplateArgs)
        {
          unsigned num_args = TemplateArgs->size();
          for (unsigned i = 0; i < num_args; ++i) {
            if (i) ret +=",";
              TemplateArgument TemplateArg = TemplateArgs->get(i);
              if (TemplateArg.getKind() == TemplateArgument::ArgKind::Type) ret += TemplateArg.getAsType().getAsString();
          }
        }
      ret += ">";
    }
    // This is a function. getQualifiedNameAsString will return a string
    // like "ANamespace::AFunction". To this we append the list of parameters
    // so that we can distinguish correctly between
    // void ANamespace::AFunction(int);
    // and
    // void ANamespace::AFunction(float);
    ret += "(";
    const FunctionType *ft = fd->getType()->castAs<FunctionType>();
    if (const FunctionProtoType *fpt = dyn_cast_or_null<FunctionProtoType>(ft))
    {
      unsigned num_params = fd->getNumParams();
      for (unsigned i = 0; i < num_params; ++i) {
        if (i)
          ret += ", ";
        ret += fd->getParamDecl(i)->getType().getAsString();
      }

      if (fpt->isVariadic()) {
        if (num_params > 0)
          ret += ", ";
        ret += "...";
      }
    }
    ret += ")";
    if (ft->isConst())
      ret += " const";
  }

  return ret;
}




bool support::isInterestingLocation(const std::string & fname) {
     if ( fname[0] == '<' && fname.find(".h")==std::string::npos ) return false;
     return true;
}


void support::writeLog(const std::string &ostring,const std::string &tfstring) {

     std::string pname = "/tmp/";
     const std::string tname = pname + tfstring;

     std::fstream file;
     file.open(tname.c_str(),std::ios::out|std::ios::app);
     file<<ostring<<"\n";
     file.close();

     return;
}

void support::fixAnonNS(std::string & name, const char * fname ){
     const std::string anon_ns = "(anonymous namespace)";
     if (name.substr(0, anon_ns.size()) == anon_ns ) {
          const char* sname = "/src/";
          const char* filename = std::strstr(fname, sname);
          if (filename != NULL) name = name.substr(0, anon_ns.size() - 1)+" in "+filename+")"+name.substr(anon_ns.size());
          }
     return;
}
 
