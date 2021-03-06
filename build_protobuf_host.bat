@ECHO OFF

SET BuildType=%1
IF "%BuildType%"=="" (
    SET BuildType=Debug
    ECHO Build Type not specified.  Using Debug configuration.
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
    -Dprotobuf_MSVC_STATIC_RUNTIME=OFF ^
    -DCMAKE_BUILD_TYPE=%BuildType% ^
    -DCMAKE_INSTALL_PREFIX=..\..\..\%HostOutputDir% ^
    -G "Ninja" ^
    ..\..\..\src\cmake\

cmake --build . --target install
POPD

ECHO Copying Compiler to Output Directories...
copy "%HostBuildDir%\%CompilerFileName%" "%CompilerOutputDir%\%CompilerFileName%"

ECHO Successfully built Protobuf for Host Architecture!
