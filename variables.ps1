$BuildDir = "build"
$OutputDir = "out"
$RootSourcePath = "./src"

$CppSourcePath = "$RootSourcePath/src"
$IncludeFilePattern = @("*.h", "*.inc")
$IncludeDir = "./$OutputDir/include"
$ExcludedFolders = "test|solaris|compiler"
$ExcludedFiles = "*test*"

$CompilerFileName = "protoc.exe"
$CompilerOutputDir = "$OutputDir/compiler"
$CompilerPath = "$CompilerOutputDir/$CompilerFileName"
