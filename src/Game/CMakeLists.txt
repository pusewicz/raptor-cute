set(NAME "Game")

set(SOURCES
    Background.swift
    Enemy.swift
    Enemy+Type.swift
    Explosion.swift
    Game.swift
    GameOverScene.swift
    GameplayScene.swift
    MainMenuScene.swift
    Player.swift
    PlayerBeam.swift
    Scene.swift
    SceneIdentifier.swift
    SceneManager.swift
    StarParticle.swift
    State.swift
)

add_library(${NAME} SHARED ${SOURCES})

target_link_libraries(${NAME} CuteFramework)
target_compile_options(${NAME} PRIVATE
    $<$<COMPILE_LANGUAGE:Swift>:-color-diagnostics>
)
