cmake_minimum_required(VERSION 3.19)

project(group-alias VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 26)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

find_package(PkgConfig REQUIRED)
pkg_check_modules(DEPS REQUIRED IMPORTED_TARGET hyprland pixman-1 libdrm lua)

add_library(group-alias SHARED src/main.cpp)

target_link_libraries(group-alias PRIVATE PkgConfig::DEPS)

# senza -fno-gnu-unique glibc non scarica mai il .so: unload/reload riuserebbe il vecchio codice
target_compile_options(group-alias PRIVATE -Wall -Wextra -Wno-unused-parameter -fno-gnu-unique)

set_target_properties(group-alias PROPERTIES PREFIX "" OUTPUT_NAME "group-alias")
