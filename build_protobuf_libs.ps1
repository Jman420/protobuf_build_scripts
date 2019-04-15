$BuildDir = "build"
$OutputDir = "out"
$RootSourcePath = "./jni"

$AndroidSdkDir = "Android/Sdk"
$AndroidCmakeExe = "$AndroidSdkDir/cmake/3.6.4111459/bin/cmake.exe"
$AndroidNinjaExe = "$AndroidSdkDir/cmake/3.6.4111459/bin/ninja.exe"
$NdkBundle = "$AndroidSdkDir/ndk-bundle/"
$ToolchainFile = "$NdkBundle/build/cmake/android.toolchain.cmake"
$ArchTargets = @("armeabi-v7a", "arm64-v8a", "x86", "x86_64")
$LibraryFilePattern = "*.a"

$CppSourcePath = "$RootSourcePath/src"
$IncludeFilePattern = @("*.h", "*.inc")
$IncludeDir = "./$OutputDir/include"
$ExcludedFolders = "test|solaris|compiler"
$ExcludedFiles = "*test*"

$JavaSourcePath = "$RootSourcePath/java"
$CompilerFileName = "protoc.exe"
$CompilerPath = "$OutputDir/compiler/$CompilerFileName"
$CompilerDestination = "$CppSourcePath/$CompilerFileName"
$JarFilePattern = "*.jar"
$JavaLiteBuildDir = "$JavaSourcePath/lite/target"
$JavaLiteOutputDir = "$OutputDir/java"

foreach ($archTarget in $ArchTargets) {
    # Remove build & output directories
    if (Test-Path $BuildDir/$archTarget) {
        Write-Output "Removing existing Build Directory for $archTarget..."
        Remove-Item $BuildDir/$archTarget -Force -Recurse
    }
    if (Test-Path $OutputDir/$archTarget) {
        Write-Output "Removing existing Output Directory for $archTarget..."
        Remove-Item $OutputDir/$archTarget -Force -Recurse
    }

    # Make Target Output Directory
    Write-Output "Creating Build & Output Directory for $archTarget ..."
    New-Item -ItemType directory -Force -Path $BuildDir/$archTarget
    New-Item -ItemType directory -Force -Path $OutputDir/$archTarget
    $fullOutputPath = Resolve-Path $OutputDir/$archTarget
    
    Write-Output "Building Protobuf for Android - $archTarget ..."
    Push-Location $BuildDir/$archTarget
    . $env:LOCALAPPDATA\$AndroidCmakeExe `
        -Dprotobuf_BUILD_TESTS=OFF `
        -Dprotobuf_BUILD_PROTOC_BINARIES=OFF `
        -Dprotobuf_BUILD_SHARED_LIBS=OFF `
        -DANDROID_NDK="$env:LOCALAPPDATA/$NdkBundle" `
        -DCMAKE_TOOLCHAIN_FILE="$env:LOCALAPPDATA/$ToolchainFile" `
        -DCMAKE_MAKE_PROGRAM="$env:LOCALAPPDATA/$AndroidNinjaExe" `
        -DCMAKE_CXX_FLAGS=-std=c++14 `
        -DANDROID_STL=c++_shared `
        -DANDROID_ABI="$archTarget" `
        -DANDROID_LINKER_FLAGS="-landroid -llog" `
        -DANDROID_CPP_FEATURES="rtti exceptions" `
        -G "Android Gradle - Ninja" `
        ../../jni/cmake/
    
    . $env:LOCALAPPDATA\$AndroidCmakeExe --build .
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
Push-Location $CppSourcePath
$sourceDirectories = (Get-ChildItem -Path . -Directory -Recurse | Where { $_.FullName -NotMatch $ExcludedFolders }).FullName | Resolve-Path -Relative
if (!$sourceDirectories) {
    Write-Output "Error : No Source Directories found!"
    Pop-Location
    exit 1
}
Write-Output "Source Directories Found : "
Write-Output "$sourceDirectories`n"
Pop-Location

# Remove Include output directory
if (Test-Path $IncludeDir) {
    Write-Output "Removing existing Output Include directory..."
    Remove-Item $IncludeDir -Force -Recurse
}

# Make the Include output directory
Write-Output "Creating output Include directory..."
New-Item -ItemType directory -Force -Path $IncludeDir
$includeFileDest = Resolve-Path $IncludeDir

# Copy Headers to Include Directory
Write-Output "Copying Include Files to $includeFileDest ..."
foreach ($sourceDir in $sourceDirectories) {
    Push-Location $CppSourcePath/$sourceDir
    $includeFiles = (Get-ChildItem -Path $IncludeFilePattern -Exclude $ExcludedFiles).FullName
    
    foreach ($includeFile in $includeFiles) {
        $fileName = Resolve-Path -Relative -Path "$includeFile"
        $fileDestination = "$includeFileDest/$sourceDir/$fileName"
        New-Item -Force $fileDestination
        Copy-Item -Force $includeFile -Destination $fileDestination
    }
    Pop-Location
}
Write-Output "Successfully copied Protobuf Include Files to $includeFileDest !"

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
