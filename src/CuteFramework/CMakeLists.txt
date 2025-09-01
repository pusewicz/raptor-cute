# CuteFramework
set(NAME "CuteFramework")

set(SOURCES CuteFramework.swift)

add_library(${NAME} SHARED ${SOURCES})

target_include_directories(${NAME} PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>)
target_link_libraries(${NAME} PUBLIC cute)
