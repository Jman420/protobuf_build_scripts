# Building Protobuf for Android

The [prepare_protobuf_src.ps1](prepare_protobuf_src.ps1) script is a Powershell script which will automatically download and extract the protobuf source code.
The [build_protobuf_host.bat](build_protobuf_host.bat) script is a Batch script which will automatically build Protobuf for the Host Architecture using Visual Studio.
The [build_protobuf_android.ps1](build_protobuf_android.ps1) script is a PowerShell script which will automatically build Protobuf C++ and Java Libraries using Android SDK & Maven.

## Steps
  - Execute the [prepare_protobuf_src.ps1](prepare_protobuf_src.ps1) script in any Powershell Prompt
  - Download the latest build of Maven from [https://maven.apache.org/download.cgi](https://maven.apache.org/download.cgi)
  - Install Maven as instructed from [https://maven.apache.org/install.html](https://maven.apache.org/install.html)
  - Install any Edition of Visual Studio with C++ Support
  - Install awk support for Windows & add it to PATH ([http://gnuwin32.sourceforge.net/packages/gawk.htm](http://gnuwin32.sourceforge.net/packages/gawk.htm))
  - Execute the [build_protobuf_host.bat](build_protobuf_host.bat) script in the Visual Studio Native Developer Command Prompt (either x86 or x64 depending on your target build)
  - Execute the [build_protobuf_android.ps1](build_protobuf_android.ps1) script in any Powershell Prompt
  - Resulting files are in /out/ directory
