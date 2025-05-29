import CuteFramework

protocol Scene: AnyObject {
  /// Called when the scene is loaded
  func load()
  
  /// Called when the scene is about to be shown
  func enter()
  
  /// Called when the scene is about to be hidden
  func exit()
  
  /// Called when the scene should be cleaned up
  func unload()
  
  /// Update the scene
  func update()
  
  /// Render the scene
  func render()
  
  /// Handle input for the scene
  func handleInput()
}

// Default implementations
extension Scene {
  func load() {}
  func enter() {}
  func exit() {}
  func unload() {}
}