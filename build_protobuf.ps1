$AndroidSdkDir = "Android/Sdk"
$CmakeExe = "$AndroidSdkDir/cmake/3.6.4111459/bin/cmake.exe"
$NinjaExe = "$AndroidSdkDir/cmake/3.6.4111459/bin/ninja.exe"
$NdkBundle = "$AndroidSdkDir/ndk-bundle/"
$ToolchainFile = "$NdkBundle/build/cmake/android.toolchain.cmake"
$ArchTargets = @("armeabi-v7a", "arm64-v8a", "x86", "x86_64")
$BuildDir = "build"
$OutputDir = "out"
$LibraryFilePattern = "*.a"

$RootSourcePath = "./jni/src"
$IncludeFilePattern = "*.h"
$IncludeDir = "./$OutputDir/include"
$ExcludedFolders = "test|solaris|compiler"

# Remove build & output directories
if (Test-Path $BuildDir) {
    Write-Output "Removing existing Build Directory..."
    Remove-Item $BuildDir -Force -Recurse
}
if (Test-Path $OutputDir) {
    Write-Output "Removing existing Output Directory..."
    Remove-Item $OutputDir -Force -Recurse
}

foreach ($archTarget in $ArchTargets) {
    # Make Target Output Directory
    Write-Output "Creating Build & Output Directory for $archTarget ..."
    New-Item -ItemType directory -Force -Path $BuildDir/$archTarget
    New-Item -ItemType directory -Force -Path $OutputDir/$archTarget
    $fullOutputPath = Resolve-Path $OutputDir/$archTarget
    
    Write-Output "Building Protobuf for Android - $archTarget ..."
    
    Push-Location $BuildDir/$archTarget
    . $env:LOCALAPPDATA\$CmakeExe `
        -Dprotobuf_BUILD_TESTS=OFF `
        -Dprotobuf_BUILD_PROTOC_BINARIES=OFF `
        -Dprotobuf_BUILD_SHARED_LIBS=OFF `
        -DANDROID_NDK="$env:LOCALAPPDATA/$NdkBundle" `
        -DCMAKE_TOOLCHAIN_FILE="$env:LOCALAPPDATA/$ToolchainFile" `
        -DCMAKE_MAKE_PROGRAM="$env:LOCALAPPDATA/$NinjaExe" `
        -DCMAKE_CXX_FLAGS=-std=c++14 `
        -DANDROID_STL=c++_shared `
        -DANDROID_ABI="$archTarget" `
        -DANDROID_LINKER_FLAGS="-landroid -llog" `
        -DANDROID_CPP_FEATURES="rtti exceptions" `
        -G "Android Gradle - Ninja" `
        ../../jni/cmake/
    
    . $env:LOCALAPPDATA\$CmakeExe --build .
    Write-Output "Successfully built Protobuf for Android - $archTarget !"
    
    Write-Output "Copying $archTarget binaries to Output Directory..."
    $libraryFiles = (Get-ChildItem -Path $LibraryFilePattern -Recurse).FullName | Resolve-Path -Relative
    foreach ($libFile in $libraryFiles) {
        $libFileDest = "$fullOutputPath/" + $libFile.Replace(".\", "").Replace("\", "/")
        Write-Output "Copying $libFile to $libFileDest ..."
        New-Item -Force $libFileDest
        Copy-Item -Force $libFile -Destination $libFileDest
    }
    Pop-Location
}
Write-Output "Successfully built Protobuf for Android!"

# Find Source Directories
Write-Output "Finding Source Directories to copy Include Files..."
Push-Location $RootSourcePath
$sourceDirectories = (Get-ChildItem -Path . -Directory -Recurse | Where { $_.FullName -NotMatch $ExcludedFolders }).FullName | Resolve-Path -Relative
if (!$sourceDirectories) {
    Write-Output "Error : No Source Directories found!"
    Pop-Location
    exit 1
}
Write-Output "Source Directories Found : "
Write-Output "$sourceDirectories`n"
Pop-Location

# Make the Include output directory
Write-Output "Creating output Include directory..."
New-Item -ItemType directory -Force -Path $IncludeDir
$includeFileDest = Resolve-Path $IncludeDir

# Copy Headers to Include Directory
Write-Output "Copying Include Files to $includeFileDest ..."
foreach ($sourceDir in $sourceDirectories) {
    Push-Location $RootSourcePath/$sourceDir
    $includeFiles = (Get-ChildItem -Path $IncludeFilePattern).FullName
    
    foreach ($includeFile in $includeFiles) {
        $fileName = Resolve-Path -Relative -Path "$includeFile"
        $fileDestination = "$includeFileDest/$sourceDir/$fileName"
        New-Item -Force $fileDestination
        Copy-Item -Force $includeFile -Destination $fileDestination
    }
    Pop-Location
}
Write-Output "Successfully copied Protobuf Include Files to $includeFileDest !"
