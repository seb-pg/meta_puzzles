If you have never used cmake... (ref https://cmake.org/cmake/help/latest/manual/cmake.1.html)

First, generate a project buildsystem for a specific build type (here Release, but could be Debug or RelWithDebInfo)
    cmake . -Bbuild/Release -DCMAKE_BUILD_TYPE=Release

Second, build the project
    cmake --build build/Release

Third, simply run
    ./build/Release/bin/test_all
