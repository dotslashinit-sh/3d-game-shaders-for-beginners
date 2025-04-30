function BuildExe() {
    # Configure CMake
    cmake . -B build
    # Build the file in release mode
    $result = (cmake --build build --config Release )
    Write-Output $result
    if($result -eq 0) {
        Write-Error "An error occurred when building the project file! Check logs for more details."
    }
    return $result
}

function CopyExe() {
    # Copies the exe file to the workspace root
    Copy-Item "./build/Release/3d-game-shaders.exe" "./"
}

$changeCache = (Test-Path "build/cache.json") ? (Get-Content "build/cache.json" | ConvertFrom-Json -AsHashTable) : @{}

function GetFileHash {
    param(
        $file
    )
    return (Get-FileHash "$file" -Algorithm SHA256).Hash
}

function SetFileHash {
    param (
        $file
    )
    $changeCache["$file"] = GetFileHash($file)
}

function CheckDiff {
    param ($file)
    return ((GetFileHash($file)) -eq ($changeCache["$file"]))
}

function MakeCache {
    if(Test-Path "build/cache.json") {
        Clear-Content "build/cache.json"
    }
    SetFileHash("CMakeLists.txt")
    SetFileHash("src/main.cxx")
    Set-Content -Path "build/cache.json" -Value ($changeCache | ConvertTo-Json)
}

$firstTime = 0

# Create a build directory
if(-not(Test-Path ./build)) {
    mkdir ./build > $null
    $firstTime = 1
}

# If CMakeLists.txt or main.cxx is changed, rebuild the executable and copy it to the root directory
if($firstTime -or -not(CheckDiff("src/main.cxx") -and CheckDiff("CMakeLists.txt"))) {
    Write-Output "Building exe file..."
    if(buildExe -eq 0) {
        Write-Output "Copying exe file..."
        copyExe
        MakeCache
    }
    Write-Output "Build script finished executing!"
}