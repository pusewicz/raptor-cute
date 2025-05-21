# CuteFramework
file(GLOB SOURCES "*.swift")

# TODO: Link as a static library for Release build
add_library(CuteFramework SHARED ${SOURCES})
target_include_directories(CuteFramework PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>)
target_link_libraries(CuteFramework SHARED cute)
