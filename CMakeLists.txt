cmake_minimum_required(VERSION 4.0)

project(
  raptor
  VERSION 0.0.1
  LANGUAGES C CXX Swift
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Make sure all binaries are placed into the same build folder.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

set(CF_FRAMEWORK_BUILD_SAMPLES OFF)
set(CF_FRAMEWORK_BUILD_TESTS OFF)

include(FetchContent)
FetchContent_Declare(
  cute
  GIT_REPOSITORY https://github.com/RandyGaul/cute_framework
  GIT_TAG master
  GIT_SHALLOW
)
FetchContent_MakeAvailable(cute)

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS "src/*.swift")

add_executable(
  ${PROJECT_NAME}
  ${SOURCES}
)

target_include_directories(${PROJECT_NAME} PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>)
target_link_libraries(${PROJECT_NAME} cute)

# Copy content directory to build directory during build
add_custom_command(
  TARGET ${PROJECT_NAME} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_directory
  ${CMAKE_CURRENT_SOURCE_DIR}/content
  ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/content
  COMMENT "Copying content directory to build directory"
)
