cmake_minimum_required(VERSION 3.10)
project(olivka_du1)

enable_language(ASM_NASM)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -no-pie")

set(ASSEMBLER_FILES asm-module.asm)

set(CMAKE_ASM_NASM_OBJECT_FORMAT elf64)
set_source_files_properties(${ASSEMBLER_FILES} PROPERTIES LANGUAGE ASM_NASM)
set_source_files_properties(${ASSEMBLER_FILES} PROPERTIES COMPILE_FLAGS "-g -Fdwarf")

add_executable(c-main c-main.c asm-module.asm)