@ECHO OFF

SET RootSourcePath=jni
SET BuildDir=build
SET OutputDir=out
SET CompilerDir=compiler
SET CompilerFileName=protoc.exe

IF EXIST "%BuildDir%\%CompilerDir%" (
    ECHO Removing existing Build Directory...
    RMDIR /S /Q "%BuildDir%\%CompilerDir%"
)
IF EXIST "%OutputDir%\%CompilerDir%" (
    ECHO Removing existing Output Directory...
    RMDIR /S /Q "%OutputDir%\%CompilerDir%"
)

ECHO Creating Build and Output Directory for Compiler...
MKDIR "%BuildDir%\%CompilerDir%"
MKDIR "%OutputDir%\%CompilerDir%"

ECHO Building Protobuf Compiler...
PUSHD "%BuildDir%\%CompilerDir%"
cmake ^
    -Dprotobuf_BUILD_TESTS=OFF ^
    -Dprotobuf_BUILD_PROTOC_BINARIES=ON ^
    -Dprotobuf_BUILD_SHARED_LIBS=OFF ^
    -G "NMake Makefiles" ^
    ..\..\jni\cmake\

nmake
POPD
ECHO Successfully built Protobuf Compiler!

ECHO Copying Protobuf Compiler to Output Directory...
copy "%BuildDir%\%CompilerDir%\%CompilerFileName%" "%OutputDir%\%CompilerDir%\%CompilerFileName%"
ECHO Successfully Copied Protobuf Compiler to Output Directory!
