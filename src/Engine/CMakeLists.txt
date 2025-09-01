set(NAME "Engine")

set(SOURCES main.swift DynamicLoader.swift)

add_executable(${NAME} ${SOURCES})

target_include_directories(${NAME} PRIVATE $<TARGET_PROPERTY:CuteFramework,INCLUDE_DIRECTORIES>)
target_link_libraries(${NAME} PUBLIC CuteFramework cute Game)
set_target_properties(${NAME} PROPERTIES
    BUILD_RPATH "${CMAKE_BINARY_DIR}"
    INSTALL_RPATH "${CMAKE_BINARY_DIR}"
)
