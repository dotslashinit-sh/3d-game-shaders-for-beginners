function buildExe() {
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

function copyExe() {
    # Copies the exe file to the workspace root
    Copy-Item ./build/Release/3d-game-shaders.exe ./
}

$firstTime = 1

# Create a build directory
if(-not(Test-Path ./build)) {
    mkdir ./build > $null
    $firstTime = 1
}

# If CMakeLists.txt or main.cxx is changed, rebuild the executable and copy it to the root directory
if($firstTime -or -not(git diff --quiet CMakeLists.txt src/main.cxx)) {
    Write-Output "Building exe file..."
    if(buildExe -eq 0) {
        Write-Output "Copying exe file..."
        copyExe
    }
    Write-Output "Build completed successfully!"
}