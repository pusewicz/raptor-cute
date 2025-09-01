set(NAME "Game")
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS *.swift)

add_library(${NAME} SHARED ${SOURCES})

target_compile_options(${NAME} PRIVATE -emit-library)
set_target_properties(${NAME} PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    Swift_MODULE_DIRECTORY "${CMAKE_BINARY_DIR}/modules"
    BUILD_RPATH "${CMAKE_BINARY_DIR}"
    INSTALL_RPATH "${CMAKE_BINARY_DIR}"
)
target_include_directories(${NAME} PRIVATE $<TARGET_PROPERTY:CuteFramework,INCLUDE_DIRECTORIES>)
target_link_libraries(${NAME} PUBLIC CuteFramework cute)
