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

add_subdirectory("third_party/pico_headers")

target_include_directories(${PROJECT_NAME} PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>)
target_link_libraries(${PROJECT_NAME} PRIVATE cute pico_headers)

# Copy content directory to build directory during build
add_custom_target(copy_data
  COMMAND ${CMAKE_COMMAND} -E copy_directory_if_different
  "${CMAKE_CURRENT_SOURCE_DIR}/content/"
  "$<TARGET_FILE_DIR:${PROJECT_NAME}>/content"
  COMMENT "Copying content"
)
add_dependencies(${PROJECT_NAME} copy_data)
