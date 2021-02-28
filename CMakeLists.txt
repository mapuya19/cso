cmake_minimum_required(VERSION 3.17)
project(cso C)

set(CMAKE_C_STANDARD 11)

add_executable(cso
        assignment1/hashing.c assignment1/tree.c)
