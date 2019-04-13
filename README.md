# Building Protobuf for Android

The [build_protobuf.ps1](build_protobuf.ps1) script is a PowerShell script which will automatically generate the necessary Android Make files for cmake to compile Protobuf for Android.

## Steps
  - Download the latest build of Protobuf from [https://github.com/protocolbuffers/protobuf](https://github.com/protocolbuffers/protobuf) (downloading the cpp zip from the Releases section will suffice)
  - Unzip the contents of the protobuf version directory (ie. protobuf-3.7.1) from the archive to the /jni/ directory in this repo
  - Execute the [build_protobuf.ps1](build_protobuf.ps1) script
  - Resulting files are in /out/ directory
