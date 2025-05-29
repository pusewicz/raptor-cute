# Raptor
set(NAME "raptor")
file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS *.swift)

add_executable(${NAME} ${SOURCES})

target_link_libraries(${NAME} CuteFramework)
