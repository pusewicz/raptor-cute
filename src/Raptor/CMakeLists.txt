# Raptor
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS "*.swift")

add_executable(
  ${PROJECT_NAME}
  ${SOURCES}
)

# TODO: Link as a static library for Release build
target_link_libraries(${PROJECT_NAME} SHARED CuteFramework)

# TODO: Move this to general Swift settings
target_compile_options(${PROJECT_NAME} PRIVATE
  $<$<COMPILE_LANGUAGE:Swift>:-color-diagnostics>
)
