set(NAME "raptor")

set(SOURCES
    App.swift
)
add_executable(${NAME} ${SOURCES})

target_link_libraries(${NAME} Game)
target_compile_options(${NAME} PRIVATE
    $<$<COMPILE_LANGUAGE:Swift>:-parse-as-library>
    $<$<COMPILE_LANGUAGE:Swift>:-color-diagnostics>
)
