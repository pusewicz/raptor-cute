cmake_minimum_required(VERSION 4.0)

project(
    raptor
    VERSION 0.0.1
    LANGUAGES C CXX Swift
)

set(SWIFT_VERSION 6)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_C_STANDARD 23)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_Swift_LANGUAGE_VERSION ${SWIFT_VERSION})
set(CMAKE_MACOSX_RPATH YES)
set(BUILD_SHARED_LIBS ON CACHE BOOL "Build shared libraries" FORCE)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_Swift_FLAGS "${CMAKE_Swift_FLAGS} -enable-library-evolution")

add_compile_options(
    $<$<COMPILE_LANGUAGE:Swift>:-color-diagnostics>
)

include(cmake/StandardProjectSettings.cmake)
include(cmake/CuteFramework.cmake)

add_subdirectory(src)

# Copy content directory to build directory during build
add_custom_target(copy_assets
    COMMAND ${CMAKE_COMMAND} -E copy_directory_if_different
    "${CMAKE_CURRENT_SOURCE_DIR}/assets/"
    "$<TARGET_FILE_DIR:Engine>/assets"
    COMMENT "Copying assets directory to build directory"
)
add_dependencies(Engine copy_assets)
