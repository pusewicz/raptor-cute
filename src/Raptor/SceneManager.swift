import CuteFramework

class SceneManager {
  private var scenes: [String: Scene] = [:]
  private var currentScene: Scene?
  private var currentSceneKey: String?
  
  // MARK: - Scene Registration
  
  func register(scene: Scene, withKey key: String) {
    scenes[key] = scene
  }
  
  func unregister(key: String) {
    if let scene = scenes.removeValue(forKey: key) {
      scene.unload()
    }
  }
  
  // MARK: - Scene Management
  
  func loadScene(_ key: String) {
    guard let scene = scenes[key] else {
      print("Scene not found: \(key)")
      return
    }
    
    scene.load()
  }
  
  func switchTo(_ key: String) {
    guard let newScene = scenes[key] else {
      print("Scene not found: \(key)")
      return
    }
    
    // Exit current scene
    if let current = currentScene {
      current.exit()
    }
    
    // Switch to new scene
    currentScene = newScene
    currentSceneKey = key
    newScene.enter()
  }
  
  func unloadScene(_ key: String) {
    guard let scene = scenes[key] else {
      return
    }
    
    // If it's the current scene, exit it first
    if currentSceneKey == key {
      scene.exit()
      currentScene = nil
      currentSceneKey = nil
    }
    
    scene.unload()
  }
  
  // MARK: - Update & Render
  
  func update() {
    currentScene?.handleInput()
    currentScene?.update()
  }
  
  func render() {
    currentScene?.render()
  }
  
  // MARK: - Utility
  
  func getCurrentSceneKey() -> String? {
    return currentSceneKey
  }
  
  func hasScene(_ key: String) -> Bool {
    return scenes[key] != nil
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
    currentSceneKey = nil
  }
  
  deinit {
    unloadAll()
  }
}