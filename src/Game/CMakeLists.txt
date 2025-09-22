set(NAME "Game")

set(SOURCES
    Components/PlayerController.swift
    Components/Position.swift
    Components/Velocity.swift
    Systems/PlayerControllerSystem.swift
    Systems/MovementSystem.swift
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

target_link_libraries(${NAME} CuteFramework Engine)
target_compile_options(${NAME} PRIVATE
    $<$<COMPILE_LANGUAGE:Swift>:-color-diagnostics>
)
