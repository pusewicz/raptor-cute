# Raptor
add_executable(
    ${PROJECT_NAME}
    Background.swift
    Enemy.swift
    Explosion.swift
    Game.swift
    Game+Update.swift
    Game+Render.swift
    Player.swift
    PlayerBeam.swift
    State.swift
    StarParticle.swift
    main.swift
)

# TODO: Link as a static library for Release build
target_link_libraries(${PROJECT_NAME} SHARED CuteFramework)

# TODO: Move this to general Swift settings
target_compile_options(${PROJECT_NAME} PRIVATE
    $<$<COMPILE_LANGUAGE:Swift>:-color-diagnostics>
)
