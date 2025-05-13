# Create a static library for pico_headers
add_library(pico_headers STATIC pico_ecs.c)

# Include directories
target_include_directories(pico_headers PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
