# Building Protobuf for Android

The [build_protobuf_compiler.bat](build_protobuf_compiler.bat) script is a Batch script which will automatically build the Protobuf Compiler using Visual Studio.
The [build_protobuf_libs.ps1](build_protobuf_libs.ps1) script is a PowerShell script which will automatically build Protobuf C++ and Java Libraries using Android SDK & Maven.

## Steps
  - Download the latest build of Protobuf Source Code from [https://github.com/protocolbuffers/protobuf](https://github.com/protocolbuffers/protobuf) (download the entire repo's master branch)
  - Unzip the contents of the protobuf directory (ie. protobuf-master) from the Source Code archive to the /jni/ directory in this repo
  - Download the latest build of Maven from [https://maven.apache.org/download.cgi](https://maven.apache.org/download.cgi)
  - Install Maven as instructed from [https://maven.apache.org/install.html](https://maven.apache.org/install.html)
  - Install any Edition of Visual Studio with C++ Support
  - Install awk support for Windows & add it to PATH ([http://gnuwin32.sourceforge.net/packages/gawk.htm](http://gnuwin32.sourceforge.net/packages/gawk.htm))
  - Execute the [build_protobuf_compiler.bat](build_protobuf_compiler.bat) script in the Visual Studio Native Developer Command Prompt
  - Execute the [build_protobuf_libs.ps1](build_protobuf_libs.ps1) script in any Powershell Prompt
  - Resulting files are in /out/ directory
