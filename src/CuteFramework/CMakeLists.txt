# CuteFramework

# TODO: Link as a static library for Release build
add_library(CuteFramework SHARED
    CF_Audio.swift
    CF_PlayDirection.swift
    CF_Sprite.swift
    CuteFramework.swift
)
target_include_directories(CuteFramework PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>)
target_link_libraries(CuteFramework SHARED cute)
