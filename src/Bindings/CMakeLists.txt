set(NAME "CuteFramework")

set(SOURCES CuteFramework.swift)

# TODO: Link as a static library for Release build
add_library(${NAME} SHARED ${SOURCES})

target_include_directories(${NAME} PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>)
target_link_libraries(${NAME} cute)
target_compile_options(${NAME} PRIVATE
    $<$<COMPILE_LANGUAGE:Swift>:-color-diagnostics>
)
