# Raptor
set(NAME "raptor")
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS *.swift)

add_executable(${NAME} ${SOURCES})

# TODO: Link as a static library for Release build
target_link_libraries(${NAME} SHARED CuteFramework)

# TODO: Move this to general Swift settings
target_compile_options(${NAME} PRIVATE
    $<$<COMPILE_LANGUAGE:Swift>:-color-diagnostics>
)
