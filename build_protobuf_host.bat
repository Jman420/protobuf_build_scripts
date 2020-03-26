@ECHO OFF

SET BuildType=%1
IF "%BuildType%"=="" (
    SET BuildType=Debug
    ECHO Build Type not specified.  Using %BuildType% configuration.
)

SET BuildDir=build
SET OutputDir=out
SET RootSourcePath=./src

SET HostBuildDir=%BuildDir%\host\%BuildType%
SET HostOutputDir=%OutputDir%\host\%BuildType%
SET CompilerOutputDir=%OutputDir%\compiler

SET CompilerFileName=protoc.exe
SET ProtobufLibName=libprotobuf.lib
SET ProtobufLiteLibName=libprotobuf-lite.lib
IF "%BuildType%"=="Debug" (
    SET ProtobufLibName=libprotobufd.lib
    SET ProtobufLiteLibName=libprotobuf-lited.lib
)

ECHO Removing Existing Build ^& Output Directories...
IF EXIST "%HostBuildDir%" (
    ECHO Removing existing Host Build Directory...
    RMDIR /S /Q "%HostBuildDir%"
)
IF EXIST "%HostOutputDir%" (
    ECHO Removing existing Host Output Directory...
    RMDIR /S /Q "%HostOutputDir%"
)
IF EXIST "%CompilerOutputDir%" (
    ECHO Removing existing Compiler Output Directory...
    RMDIR /S /Q "%CompilerOutputDir%"
)

ECHO Creating Build ^& Output Directories for Host ^& Compiler...
MKDIR %HostBuildDir%
MKDIR %HostOutputDir%
MKDIR %CompilerOutputDir%

ECHO Building Protobuf for Host Architecture...
PUSHD %HostBuildDir%
cmake ^
    -Dprotobuf_BUILD_TESTS=OFF ^
    -Dprotobuf_BUILD_PROTOC_BINARIES=ON ^
    -Dprotobuf_BUILD_SHARED_LIBS=OFF ^
    -DCMAKE_BUILD_TYPE=%BuildType% ^
    -G "Ninja" ^
    ..\..\..\src\cmake\

ninja
POPD
ECHO Successfully built Protobuf for Host Architecture!

ECHO Copying Compiler to Output Directories...
copy "%HostBuildDir%\%CompilerFileName%" "%CompilerOutputDir%\%CompilerFileName%"

ECHO Copying Host Libraries to Output Directories...
copy "%HostBuildDir%\%ProtobufLibName%" "%HostOutputDir%\%ProtobufLibName%"
copy "%HostBuildDir%\%ProtobufLiteLibName%" "%HostOutputDir%\%ProtobufLiteLibName%"
ECHO Succesfully Copied Host Compiler ^& Libraries to Output Directories!
ECHO Execute copy_include_headers.ps1 in Powershell to copy the Protobuf Include Headers.
