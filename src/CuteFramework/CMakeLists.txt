# CuteFramework
set(NAME "CuteFramework")
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS *.swift)

# TODO: Link as a static library for Release build
add_library(${NAME} SHARED ${SOURCES})

target_include_directories(${NAME} PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>)
target_link_libraries(${NAME} cute)
