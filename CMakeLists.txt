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

# Make sure all binaries are placed into the same build folder.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

include(cmake/cute.cmake)

add_subdirectory(src)

# Copy content directory to build directory during build
add_custom_target(copy_data
  COMMAND ${CMAKE_COMMAND} -E copy_directory_if_different
  "${CMAKE_CURRENT_SOURCE_DIR}/content/"
  "$<TARGET_FILE_DIR:${PROJECT_NAME}>/content"
  COMMENT "Copying content"
)
add_dependencies(${PROJECT_NAME} copy_data)
