$RootSourcePath = "./jni"
$RepoUrl = "https://github.com/protocolbuffers/protobuf/archive/master.zip"
$RepoZipFile = "./protobuf-master.zip"
$RootZipFolder = "protobuf-master"

Write-Output "Preparing Protobuf Source Code Directory..."
if (Test-Path $RepoZipFile) {
    Write-Output "Removing existing Protobuf Repo Zip File..."
    Remove-Item $RepoZipFile -Force
}
Write-Output "Downloading Protobuf Repo Zip File..."
Start-BitsTransfer -Source $RepoUrl -Destination $RepoZipFile

if (Test-Path $RootSourcePath) {
    Write-Output "Removing Protobuf Source Code Directory..."
    Remove-Item $RootSourcePath -Recurse -Force
}
Write-Output "Unzipping Protobuf Repo to Protobuf Source Code Directory..."
7z x "$RepoZipFile" -r
mv ./$RootZipFolder $RootSourcePath
Write-Output "Successfully prepared Protobuf Source Code!"
