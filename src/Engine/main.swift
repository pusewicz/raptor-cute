import CuteFramework
import Foundation

var shouldReload = false
let reloadSignalSource = DispatchSource.makeSignalSource(signal: SIGHUP, queue: .global())
reloadSignalSource.setEventHandler {
  shouldReload = true
}
signal(SIGHUP, SIG_IGN)
reloadSignalSource.resume()

let loader = DynamicLoader()
let libraryPath = "\(FileManager.default.currentDirectoryPath)/lib/libGame"
if !loader.loadLibrary(basePath: libraryPath) {
  print("Failed to load game library")
  cf_destroy_app()
  exit(1)
}

print("Process PID: \(getpid())")
print("Send SIGHUP to trigger hot reload: kill -HUP \(getpid())")

let scale: Int32 = 4
let scaleV2 = CF_V2(scale, scale)
let screenSize: Int32 = 64 * 3

let options: CF_AppOptionFlags = Int32(CF_APP_OPTIONS_WINDOW_POS_CENTERED_BIT.rawValue)

print("Creating Raptor game...")
print(
  "Screen size: logical(\(screenSize) x \(screenSize)), physical(\(screenSize * scale) x \(screenSize * scale))"
)

let result = cf_make_app(
  "Raptor", 0, 0, 0, screenSize * scale, screenSize * scale, options,
  CommandLine.unsafeArgv[0])

guard !cf_is_error(result) else {
  fatalError("Could not make app")
}

cf_app_set_vsync(true)
cf_set_target_framerate(60)
cf_set_fixed_timestep(60)
cf_set_fixed_timestep_max_updates(5)

cf_app_init_imgui()

guard let base = cf_fs_get_base_directory() else {
  fatalError("Could not get base directoy")
}
var path = String(cString: base)
path += "assets"
cf_fs_mount(path, "/", false)
cf_shader_directory("/assets/shaders")

while cf_app_is_running() {
  if shouldReload {
    shouldReload = false
    print("SIGHUP received, reloading game logic...")
    loader.loadLibrary(basePath: libraryPath)
  }

  cf_app_update({ _ in
    withUnsafeMutablePointer(to: &gameState) { gameStatePtr in
      withUnsafePointer(to: inputState) { inputStatePtr in
        loader.gameUpdate?(gameStatePtr, inputStatePtr)
      }
    }
    withUnsafePointer(to: gameState) { gameStatePtr in
      loader.gameRender?(gameStatePtr)
    }
  })

  cf_app_draw_onto_screen(true)
}

reloadSignalSource.cancel()
cf_destroy_app()
