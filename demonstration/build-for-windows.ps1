# Create a build directory
if(-not(Test-Path ./build)) {
    mkdir ./build
}

# Configure CMake
cmake . -B build
cmake --build build --config Release