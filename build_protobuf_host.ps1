. ./variables.ps1

$HostBuildDir = "$BuildDir/host"
$HostOutputDir = "$OutputDir/host"
$CompilerOutputDir = "$OutputDir/compiler"

$ProtobufLibName = "libprotobufd.lib"
$ProtobufLiteLibName = "libprotobuf-lited.lib"

Write-Output "Removing Existing Build & Output Directories..."
if (Test-Path $HostBuildDir) {
    Write-Output "Removing existing Host Build Directory..."
    Remove-Item $HostBuildDir -Force -Recurse
}
if (Test-Path $HostOutputDir) {
    Write-Output "Removing existing Host Output Directory..."
    Remove-Item $HostOutputDir -Force -Recurse
}
if (Test-Path $CompilerOutputDir) {
    Write-Output "Removing existing Compiler Output Directory..."
    Remove-Item $CompilerOutputDir -Force -Recurse
}

Write-Output "Creating Build & Output Directories for Host & Compiler..."
New-Item -ItemType directory -Force -Path $HostBuildDir
New-Item -ItemType directory -Force -Path $HostOutputDir
New-Item -ItemType directory -Force -Path $CompilerOutputDir

Write-Output "Building Protobuf for Host Architecture..."
Push-Location $HostBuildDir
cmake `
    -Dprotobuf_BUILD_TESTS=OFF `
    -Dprotobuf_BUILD_PROTOC_BINARIES=ON `
    -Dprotobuf_BUILD_SHARED_LIBS=OFF `
    -G "NMake Makefiles" `
    "../../$RootSourcePath/cmake"

nmake
Pop-Location
Write-Output "Successfully built Protobuf for Host Architecture!"

& "$PSScriptRoot\copy_include_headers.ps1"

Write-Output "Copying Compiler to Output Directories..."
New-Item -Force $CompilerOutputDir/$CompilerFileName
Copy-Item -Force $HostBuildDir/$CompilerFileName -Destination $CompilerOutputDir/$CompilerFileName

Write-Output "Copying Host Libraries to Output Directories..."
New-Item -Force $HostOutputDir/$ProtobufLibName
Copy-Item -Force $HostBuildDir/$ProtobufLibName -Destination $HostOutputDir/$ProtobufLibName

New-Item -Force $HostOutputDir/$ProtobufLiteLibName
Copy-Item -Force $HostBuildDir/$ProtobufLiteLibName -Destination $HostOutputDir/$ProtobufLiteLibName
Write-Output "Succesfully Copied Host Compiler & Libraries to Output Directories!"
