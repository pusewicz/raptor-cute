import Foundation

final class DynamicLoader {
  private var handle: UnsafeMutableRawPointer?
  private var currentLibPath: String?

  typealias InitFunc = @convention(c) () -> Void
  typealias UpdateFunc = @convention(c) (UnsafeMutableRawPointer, UnsafeRawPointer) -> Void
  typealias RenderFunc = @convention(c) (UnsafeRawPointer) -> Void
  typealias ShutdownFunc = @convention(c) () -> Void

  var gameInit: InitFunc?
  var gameUpdate: UpdateFunc?
  var gameRender: RenderFunc?
  var gameShutdown: ShutdownFunc?

  @discardableResult
  func loadLibrary(basePath: String) -> Bool {
    let originalPath = "\(basePath).dylib"

    // Create a temporary copy with unique timestamp
    let timestamp = Int(Date().timeIntervalSince1970 * 1_000_000)  // microseconds
    let tempPath = "\(basePath)_\(timestamp).dylib"

    do {
      try FileManager.default.copyItem(atPath: originalPath, toPath: tempPath)
    } catch {
      print("Failed to copy library: \(error)")
      return false
    }

    // Unload old library if exists
    if let oldHandle = handle {
      gameShutdown?()
      dlclose(oldHandle)
    }

    // Clean up old temp file
    if let oldPath = currentLibPath {
      try? FileManager.default.removeItem(atPath: oldPath)
    }

    // Load new library
    guard let newHandle = dlopen(tempPath, RTLD_NOW | RTLD_LOCAL) else {
      if let error = dlerror() {
        print("Failed to load library: \(String(cString: error))")
      }
      try? FileManager.default.removeItem(atPath: tempPath)
      return false
    }

    handle = newHandle
    currentLibPath = tempPath

    // Get function pointers
    if let symbol = dlsym(newHandle, "gameInit") {
      gameInit = unsafeBitCast(symbol, to: InitFunc?.self)
    }
    if let symbol = dlsym(newHandle, "gameUpdate") {
      gameUpdate = unsafeBitCast(symbol, to: UpdateFunc?.self)
    }
    if let symbol = dlsym(newHandle, "gameRender") {
      gameRender = unsafeBitCast(symbol, to: RenderFunc?.self)
    }
    if let symbol = dlsym(newHandle, "gameShutdown") {
      gameShutdown = unsafeBitCast(symbol, to: ShutdownFunc?.self)
    }

    // Initialize the new library
    gameInit?()

    print("Hot reload successful: \(tempPath)")
    return true
  }

  deinit {
    if let handle = handle {
      gameShutdown?()
      dlclose(handle)
    }
    if let path = currentLibPath {
      try? FileManager.default.removeItem(atPath: path)
    }
  }
}
