set(NAME "Engine")

set(SOURCES
    ECS.swift
)
add_library(${NAME} SHARED ${SOURCES})

target_compile_options(${NAME} PRIVATE
    $<$<COMPILE_LANGUAGE:Swift>:-color-diagnostics>
)
