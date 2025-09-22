import CuteFramework

@MainActor
protocol Scene: AnyObject {
  /// Called when the scene is loaded
  func load()

  /// Called when the scene is about to be shown
  func enter() async

  /// Called when the scene is about to be hidden
  func exit()

  /// Called when the scene should be cleaned up
  func unload()

  /// Update the scene
  func update() async

  /// Render the scene
  func render()

  /// Handle input for the scene
  func handleInput() async
}

// Default implementations
extension Scene {
  func load() {}
  func enter() async {}
  func exit() {}
  func unload() {}
}
