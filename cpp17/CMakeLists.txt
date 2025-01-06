cmake_minimum_required(VERSION 3.11)

project(MetaPuzzles CXX)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

add_compile_options(-pedantic -pedantic-errors)
add_compile_options(-Wall)
add_compile_options(-Wextra)

add_compile_options(-Woverloaded-virtual)
add_compile_options(-Wredundant-decls)
add_compile_options(-Wshadow)
add_compile_options(-Wswitch-default)
add_compile_options(-Wuninitialized)
add_compile_options(-Wunused-parameter)

add_compile_options(-Warith-conversion)
add_compile_options(-Wconversion)
add_compile_options(-Wdouble-promotion)
add_compile_options(-Wfloat-conversion)
#add_compile_options(-Wfloat-equal)
add_compile_options(-Wold-style-cast)
add_compile_options(-Wcast-qual)
add_compile_options(-Wcast-align=strict)

add_compile_options(-Wformat=2)
add_compile_options(-Wformat-signedness)
add_compile_options(-Wmissing-include-dirs)
add_compile_options(-Wnull-dereference)

add_compile_options(-pthread)

set(CMAKE_CXX_FLAGS_DEBUG "-g")
set(CMAKE_CXX_FLAGS_RELEASE "-o2")
set(CMAKE_CXX_FLAGS_RELWIHDEBINFO "-g -o3")

#set(LINK_FLAGS "-flto")
set(CMAKE_EXE_LINKER_FLAGS "-static-libstdc++")

SET(CMAKE_CXX_STANDARD_REQUIRED ON)
SET(CMAKE_CXX_EXTENSIONS OFF)
SET(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(test_all test_all.cpp)
