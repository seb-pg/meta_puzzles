cmake_minimum_required(VERSION 3.11)

project(MetaPuzzles CXX)

get_filename_component(CMAKE_SOURCE_DIR ${CMAKE_SOURCE_DIR} ABSOLUTE)
get_filename_component(CMAKE_BINARY_DIR ${CMAKE_BINARY_DIR} ABSOLUTE)
if (CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
    message(SEND_ERROR "cmake command line is missing -B {build_target}/{build_type}")
endif()

if(NOT DEFINED CMAKE_BUILD_TYPE)
    message(SEND_ERROR "cmake command line is missing -DCMAKE_BUILD_TYPE={build_type}, where build_type must in [Debug Release RelWithDebInfo]")
endif()

if(NOT "${CMAKE_CXX_STANDARD}" IN_LIST "17 20 23 26")
    set(CMAKE_CXX_STANDARD 17)
endif()

message("CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}")
message("CMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}")
set(CMAKE_CXX_STANDARD ${CMAKE_CXX_STANDARD} CACHE STRING "Choose the type of build, options are: None 17 20 23 26" FORCE)

#set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/build)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

SET(CMAKE_CXX_FLAGS -pedantic -pedantic-errors
                    -Wall -Wextra
                    -Woverloaded-virtual -Wredundant-decls -Wshadow -Wswitch-default -Wuninitialized -Wunused-parameter
                    -Warith-conversion -Wconversion -Wdouble-promotion -Wfloat-conversion -Wold-style-cast -Wcast-qual -Wcast-align=strict
                    -Wformat=2 -Wformat-signedness -Wmissing-include-dirs -Wnull-dereference
                    -pthread)
string (REPLACE ";" " " CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
SET(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} CACHE STRING "Flags used by the CXX compiler during all build types." FORCE)
set(CMAKE_EXE_LINKER_FLAGS "-static-libstdc++")

SET(CMAKE_CXX_STANDARD_REQUIRED ON)
SET(CMAKE_CXX_EXTENSIONS OFF)
SET(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(test_all test_all.cpp)
