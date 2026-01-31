cmake_minimum_required(VERSION 3.10)
project(ContrekCore C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -pthread -g -march=native -DNDEBUG -Ofast -flto")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O3 -march=native -fPIC -DNDEBUG")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pthread -flto=auto -Wl,--no-as-needed")

find_package(ZLIB REQUIRED)

file(GLOB_RECURSE CPP_SOURCES "*.cpp")
file(GLOB_RECURSE C_SOURCES "*.c")

list(FILTER CPP_SOURCES EXCLUDE REGEX "examples/.*\\.cpp")

add_library(ContrekLib STATIC ${CPP_SOURCES} ${C_SOURCES})

file(GLOB_RECURSE ALL_HEADERS "*.h")
foreach(header_file ${ALL_HEADERS})
    get_filename_component(header_dir ${header_file} DIRECTORY)
    list(APPEND ALL_INCLUDE_DIRS ${header_dir})
endforeach()
list(REMOVE_DUPLICATES ALL_INCLUDE_DIRS)

target_include_directories(ContrekLib PUBLIC ${ALL_INCLUDE_DIRS} ${ZLIB_INCLUDE_DIRS})
target_link_libraries(ContrekLib PRIVATE ${ZLIB_LIBRARIES} pthread)

option(BUILD_EXAMPLES "Build the example application" OFF)

if(BUILD_EXAMPLES)
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/examples/example.cpp")
        message(STATUS "Contrek: Compiling example option ON")
        add_executable(contrek_test examples/example.cpp)
        target_link_libraries(contrek_test PRIVATE ContrekLib)
    else()
        message(WARNING "Contrek: examples/example.cpp not found!")
    endif()
endif()