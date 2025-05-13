# Create a static library for pico_headers
add_library(pico_headers STATIC)

# Add source files to the library
file(GLOB HEADER_SOURCES *.c)
target_sources(pico_headers PRIVATE ${HEADER_SOURCES})

# Include directories
target_include_directories(pico_headers PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
