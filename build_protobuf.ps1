$AndroidSdkDir = "Android/Sdk"
$CmakeExe = "$AndroidSdkDir/cmake/3.6.4111459/bin/cmake.exe"
$NinjaExe = "$AndroidSdkDir/cmake/3.6.4111459/bin/ninja.exe"
$NdkBundle = "$AndroidSdkDir/ndk-bundle/"
$ToolchainFile = "$NdkBundle/build/cmake/android.toolchain.cmake"
$OutputDir = "out"
$ArmV7Dir = "$OutputDir/armeabi-v7a"
$ArmV8Dir = "$OutputDir/arm64-v8a"
$X86Dir = "$OutputDir/x86"
$X86_64Dir = "$OutputDir/x86_64"

# Remove output directories
Remove-Item $OutputDir -Force -Recurse

# Make output directories
New-Item -ItemType directory -Force -Path $ArmV7Dir
New-Item -ItemType directory -Force -Path $ArmV8Dir
New-Item -ItemType directory -Force -Path $X86Dir
New-Item -ItemType directory -Force -Path $X86_64Dir

# Build Arm-v7a
Write-Output "Building Protobuf for Android - armeabi-v7a ..."
Push-Location $ArmV7Dir
. $env:LOCALAPPDATA\$CmakeExe `
-Dprotobuf_BUILD_TESTS=OFF `
-Dprotobuf_BUILD_PROTOC_BINARIES=OFF `
-Dprotobuf_BUILD_SHARED_LIBS=OFF `
-DANDROID_NDK="$env:LOCALAPPDATA/$NdkBundle" `
-DCMAKE_TOOLCHAIN_FILE="$env:LOCALAPPDATA/$ToolchainFile" `
-DCMAKE_MAKE_PROGRAM="$env:LOCALAPPDATA/$NinjaExe" `
-DCMAKE_CXX_FLAGS=-std=c++14 `
-DANDROID_STL=c++_shared `
-DANDROID_ABI=armeabi-v7a `
-DANDROID_LINKER_FLAGS="-landroid -llog" `
-DANDROID_CPP_FEATURES="rtti exceptions" `
-G "Android Gradle - Ninja" `
../../jni/cmake/

. $env:LOCALAPPDATA\$CmakeExe --build .
Pop-Location

# Build Arm-v8a
Write-Output "Building Protobuf for Android - arm64-v8a ..."
Push-Location $ArmV8Dir
. $env:LOCALAPPDATA\$CmakeExe `
-Dprotobuf_BUILD_TESTS=OFF `
-Dprotobuf_BUILD_PROTOC_BINARIES=OFF `
-Dprotobuf_BUILD_SHARED_LIBS=OFF `
-DANDROID_NDK="$env:LOCALAPPDATA/$NdkBundle" `
-DCMAKE_TOOLCHAIN_FILE="$env:LOCALAPPDATA/$ToolchainFile" `
-DCMAKE_MAKE_PROGRAM="$env:LOCALAPPDATA/$NinjaExe" `
-DCMAKE_CXX_FLAGS=-std=c++14 `
-DANDROID_STL=c++_shared `
-DANDROID_ABI=arm64-v8a `
-DANDROID_LINKER_FLAGS="-landroid -llog" `
-DANDROID_CPP_FEATURES="rtti exceptions" `
-G "Android Gradle - Ninja" `
../../jni/cmake/

. $env:LOCALAPPDATA\$CmakeExe --build .
Pop-Location

# Build x86
Write-Output "Building Protobuf for Android - x86 ..."
Push-Location $X86Dir
. $env:LOCALAPPDATA\$CmakeExe `
-Dprotobuf_BUILD_TESTS=OFF `
-Dprotobuf_BUILD_PROTOC_BINARIES=OFF `
-Dprotobuf_BUILD_SHARED_LIBS=OFF `
-DANDROID_NDK="$env:LOCALAPPDATA/$NdkBundle" `
-DCMAKE_TOOLCHAIN_FILE="$env:LOCALAPPDATA/$ToolchainFile" `
-DCMAKE_MAKE_PROGRAM="$env:LOCALAPPDATA/$NinjaExe" `
-DCMAKE_CXX_FLAGS=-std=c++14 `
-DANDROID_STL=c++_shared `
-DANDROID_ABI=x86 `
-DANDROID_LINKER_FLAGS="-landroid -llog" `
-DANDROID_CPP_FEATURES="rtti exceptions" `
-G "Android Gradle - Ninja" `
../../jni/cmake/

. $env:LOCALAPPDATA\$CmakeExe --build .
Pop-Location

# Build x86_64
Write-Output "Building Protobuf for Android - x86_64 ..."
Push-Location $X86_64Dir
. $env:LOCALAPPDATA\$CmakeExe `
-Dprotobuf_BUILD_TESTS=OFF `
-Dprotobuf_BUILD_PROTOC_BINARIES=OFF `
-Dprotobuf_BUILD_SHARED_LIBS=OFF `
-DANDROID_NDK="$env:LOCALAPPDATA/$NdkBundle" `
-DCMAKE_TOOLCHAIN_FILE="$env:LOCALAPPDATA/$ToolchainFile" `
-DCMAKE_MAKE_PROGRAM="$env:LOCALAPPDATA/$NinjaExe" `
-DCMAKE_CXX_FLAGS=-std=c++14 `
-DANDROID_STL=c++_shared `
-DANDROID_ABI=x86_64 `
-DANDROID_LINKER_FLAGS="-landroid -llog" `
-DANDROID_CPP_FEATURES="rtti exceptions" `
-G "Android Gradle - Ninja" `
../../jni/cmake/

. $env:LOCALAPPDATA\$CmakeExe --build .
Pop-Location

Write-Output "Successfully built Protobuf for Android!"