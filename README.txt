
=== CLANG CMS ===

This are the CMS clang static analyzer checkers to crawl C/C++ code for constructs which my become problematic when running multi-threaded code or do violate CMS Framework Rules.

by Thomas Hauth - Thomas.Hauth@cern.ch and
Patrick Gartung - gartung@fnal.gov


== Available Checkers == 

threadsafety.ConstCastAway  "Checks for casts which remove const qualifier and might result in thread-unsafe code"
threadsafety.ConstCast      "Checks for casts which remove const qualifier and might result in thread-unsafe code" 
threadsafety.StaticLocal    "Checks for non-const method local statics which might not be thread-safe"
threadsafety.MutableMember  "Checks for members with the mutable keyword which might not be thread-safe"
threadsafety.GlobalStatic   "Checks for global non-const statics which might not be thread-safe"
optional.ClassChecker       "Checks data classes for thread safety issues"
optional.FunctionChecker    "Reports functions which access non-const statics"

== Compile LLVM / clang  ==

The minimum required version of llvm/clang required to compile the module is v3.5
The minimum required version of gcc/g++ required to compile llvm/clang is v4.7

Follow the directions to obtain and compile LLVM/clang here:

http://clang.llvm.org/get_started.html#build

If you are compiling on RHEL6 or similar systems install the devtoolset-1.1 package.
If you are compiling on Ubuntu 14 systems install build-essentials package group.

Build and install llvm/clang on your system. Note the location if the install directory. 

Now, checkout the repository which contains the CMS extensions into the same folder :

git clone https://github.com/gartung/clang_cms.git 

and run

PATH=<llvm/clang install dir>/bin:$PATH 
cmake .
make 

inside the clang_cms folder. If you need to disable the CMS-specific filters, you can to so in CMakeLists.txt. If you encounter problems with missing files or directories, you may need to edit the file CMakeLists.txt to adapt it to your specific build configuration.

The CMS specific checkers have now been compiled into an external library in clang_cms/libclangSAplugin.so . 

== Test on a small example  ==

Export the path to the new clang binary ( Bash example ):

export PATH=<llvm install dir>/bin/:$PATH


To see a listing of all available checkers, also the CMS-specific ones, you can run the scan-build command:

<llvm install dir>/tools/clang/tools/scan-build/scan-build -load-plugin libclangSAplugin.so


Test out the newly compiled and modified clang, cd into the clang_cms/test folder and run:

<llvm install dir>/tools/clang/tools/scan-build/scan-build -load-plugin ../lib/libclangSAplugin.so -enable-checker threadsafety make -B

This will produce a clang static analyzer html your can open in your favorite browser. You can find the location in the output line, something along the lines:

scan-build: 6 bugs found.
scan-build: Run 'scan-view /tmp/scan-build-2012-04-26-13' to examine bug reports.


You then call:
firefox /tmp/scan-build-2012-04-26-13/index.html

You will need to include the paths to clang, scan-build and scan-view in your path

export PATH=$PATH\:(llvm install path)/bin/\:(llvm install path)/tools/clang/tools/scan-build/\:(llvm install path)/tools/clang/tools/scan-view/

If you also want to generate the reports for thread-safety, you also need to add the additional parameters to scan-build.
