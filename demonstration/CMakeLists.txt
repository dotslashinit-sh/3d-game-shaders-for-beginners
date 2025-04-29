cmake_minimum_required(VERSION 3.10)
project(3DGameShadersForBeginners LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED true)

add_executable(3d-game-shaders src/main.cxx)
find_package(Python3 REQUIRED)
set(PandaPath "C:\\Panda3D-1.10.15-x64" CACHE STRING "Path to the root of panda sdk")
list(APPEND LIBRARIES
    libp3framework
    libpanda
    libpandafx
    libpandaexpress
    libpandaphysics
    libp3dtoolconfig
    libp3dtool
)
target_link_directories(3d-game-shaders PRIVATE "${PandaPath}/lib")
target_include_directories(3d-game-shaders PRIVATE "${PandaPath}/include")
target_link_libraries(3d-game-shaders PRIVATE ${LIBRARIES})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})