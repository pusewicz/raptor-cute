import CuteFramework

@MainActor
class SceneManager {
  enum SceneIdentifier: String, CaseIterable {
    case mainMenu = "mainmenu"
    case gamePlay = "gameplay"
    case gameOver = "gameover"
  }

  private var scenes: [SceneIdentifier: Scene] = [:]
  private var currentScene: Scene?
  private var currentSceneIdentifier: SceneIdentifier?

  // MARK: - Scene Registration

  func register(scene: Scene, for identifier: SceneIdentifier) {
    scenes[identifier] = scene
  }

  func unregister(identifier: SceneIdentifier) {
    if let scene = scenes.removeValue(forKey: identifier) {
      scene.unload()
    }
  }

  // MARK: - Scene Management

  func loadScene(_ identifier: SceneIdentifier) {
    guard let scene = scenes[identifier] else {
      print("Scene not found: \(identifier.rawValue)")
      return
    }

    scene.load()
  }

  func switchTo(_ identifier: SceneIdentifier) async {
    guard let newScene = scenes[identifier] else {
      print("Scene not found: \(identifier.rawValue)")
      return
    }

    // Exit current scene
    if let current = currentScene {
      current.exit()
    }

    // Switch to new scene
    currentScene = newScene
    currentSceneIdentifier = identifier
    await newScene.enter()
  }

  func unloadScene(_ identifier: SceneIdentifier) {
    guard let scene = scenes[identifier] else {
      return
    }

    // If it's the current scene, exit it first
    if currentSceneIdentifier == identifier {
      scene.exit()
      currentScene = nil
      currentSceneIdentifier = nil
    }

    scene.unload()
  }

  // MARK: - Update & Render

  func update() async {
    await currentScene?.handleInput()
    await currentScene?.update()
  }

  func render() {
    currentScene?.render()
  }

  // MARK: - Utility

  func getCurrentSceneIdentifier() -> SceneIdentifier? {
    return currentSceneIdentifier
  }

  func hasScene(_ identifier: SceneIdentifier) -> Bool {
    return scenes[identifier] != nil
  }

  // MARK: - Cleanup

  func unloadAll() {
    // Exit current scene
    if let current = currentScene {
      current.exit()
    }

    // Unload all scenes
    for (_, scene) in scenes {
      scene.unload()
    }

    scenes.removeAll()
    currentScene = nil
    currentSceneIdentifier = nil
  }
}
