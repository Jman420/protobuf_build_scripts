. ./variables.ps1

$AndroidSdkDir = "Android/Sdk"
$CmakeVersion = "3.10.2.4988404"
$AndroidCmakeExe = "$AndroidSdkDir/cmake/$CmakeVersion/bin/cmake.exe"
$AndroidNinjaExe = "$AndroidSdkDir/cmake/$CmakeVersion/bin/ninja.exe"
$NdkVersion = "21.1.6352462"
$NdkBundle = "$AndroidSdkDir/ndk/$NdkVersion"
$ToolchainFile = "$NdkBundle/build/cmake/android.toolchain.cmake"
$ArchTargets = @("armeabi-v7a", "arm64-v8a", "x86", "x86_64")
$LibraryFilePattern = "*.a"
$AndroidBuildDir = "$BuildDir/android"
$AndroidOutputDir = "$OutputDir/android"

$CompilerDestination = "$CppSourcePath/$CompilerFileName"
$JavaSourcePath = "$RootSourcePath/java"
$JarFilePattern = "*.jar"
$JavaLiteBuildDir = "$JavaSourcePath/lite/target"
$JavaLiteOutputDir = "$OutputDir/java"

foreach ($archTarget in $ArchTargets) {
    $archBuildDir = "$AndroidBuildDir/$archTarget"
    $archOutputDir = "$AndroidOutputDir/$archTarget"

    # Remove build & output directories
    Write-Output "Removing Existing Build & Output Directories for $archTarget ..."
    if (Test-Path $archBuildDir) {
        Write-Output "Removing existing Build Directory for $archTarget ..."
        Remove-Item $archBuildDir -Force -Recurse
    }
    if (Test-Path $archOutputDir) {
        Write-Output "Removing existing Output Directory for $archTarget ..."
        Remove-Item $archOutputDir -Force -Recurse
    }

    # Make Target Output Directory
    Write-Output "Creating Build & Output Directory for $archTarget ..."
    New-Item -ItemType directory -Force -Path $archBuildDir
    New-Item -ItemType directory -Force -Path $archOutputDir
    $fullOutputPath = Resolve-Path $archOutputDir
    
    Write-Output "Building Protobuf for Android - $archTarget ..."
    Push-Location $archBuildDir
    . $env:LOCALAPPDATA\$AndroidCmakeExe `
        -Dprotobuf_BUILD_TESTS=OFF `
        -Dprotobuf_BUILD_PROTOC_BINARIES=OFF `
        -Dprotobuf_BUILD_SHARED_LIBS=OFF `
        -DCMAKE_BUILD_TYPE=Release `
        -DANDROID_NDK="$env:LOCALAPPDATA/$NdkBundle" `
        -DCMAKE_TOOLCHAIN_FILE="$env:LOCALAPPDATA/$ToolchainFile" `
        -DCMAKE_MAKE_PROGRAM="$env:LOCALAPPDATA/$AndroidNinjaExe" `
        -DCMAKE_CXX_FLAGS=-std=c++14 `
        -DANDROID_STL=c++_shared `
        -DANDROID_ABI="$archTarget" `
        -DANDROID_LINKER_FLAGS="-landroid -llog" `
        -DANDROID_CPP_FEATURES="rtti exceptions" `
        -DCMAKE_INSTALL_PREFIX="$fullOutputPath" `
        -G "Ninja" `
        "../../../$RootSourcePath/cmake"
    
    . $env:LOCALAPPDATA\$AndroidCmakeExe --build . --target install
    Write-Output "Successfully built Protobuf for Android - $archTarget !"
    Pop-Location
}
Write-Output "Successfully built Protobuf for Android!"

# Build Java Libraries
Write-Output "Copying Protobuf Compiler to compile location..."
New-Item -Force $CompilerDestination
Copy-Item -Force $CompilerPath -Destination $CompilerDestination
Write-Output "Successfully copied Protobuf Compiler to compile location!"

Write-Output "Building Java Packages..."
Push-Location $JavaSourcePath
. mvn -DskipTests package
Pop-Location
Write-Output "Successfully built Java Packages!"

# Copy Java Library
Write-Output "Copying Protobuf-lite Jar to Output Directory..."
Push-Location $JavaLiteBuildDir
$liteJar = (Get-ChildItem -Path $JarFilePattern).Name
Pop-Location
Write-Output "Found Protobuf-lite Jar : $liteJar"
New-Item -Force $JavaLiteOutputDir/$liteJar
Copy-Item -Force $JavaLiteBuildDir/$liteJar -Destination $JavaLiteOutputDir/$liteJar
Write-Output "Successfully copied Java Protobuf-lite Jar to Output Directory!"
