import CuteFramework

class Game {
  nonisolated(unsafe) static weak var current: Game!

  let screenSize: Int32 = 64 * 3
  let scale: Int32 = 4
  let scaleV2: CF_V2

  /// Screen width and height
  var width: Int32 = 0
  var height: Int32 = 0

  var canvasWidth: Int32 {
    return width / scale
  }

  var canvasHeight: Int32 {
    return height / scale
  }

  var drawCount: Int32 = 0

  // Scene Management
  let sceneManager = SceneManager()

  init() {
    self.scaleV2 = CF_V2(x: Float(scale), y: Float(scale))

    let options: CF_AppOptionFlags = Int32(CF_APP_OPTIONS_WINDOW_POS_CENTERED_BIT.rawValue)

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
    cf_app_get_size(&width, &height)

    mountAssetsDirectory(as: "/")

    Game.current = self

    // Register scenes
    let mainMenuScene = MainMenuScene(game: self)
    let gameplayScene = GameplayScene(game: self)

    sceneManager.register(scene: mainMenuScene, withKey: "mainmenu")
    sceneManager.register(scene: gameplayScene, withKey: "gameplay")

    // Load scenes
    sceneManager.loadScene("mainmenu")
    sceneManager.loadScene("gameplay")

    // Start with main menu
    sceneManager.switchTo("mainmenu")
  }

  func mountAssetsDirectory(as dest: String) {
    guard let base = cf_fs_get_base_directory() else {
      fatalError("Could not get base directoy")
    }
    var path = String(cString: base)
    path += "assets"
    cf_fs_mount(path, dest, false)
  }

  func run() {
    while cf_app_is_running() {
      cf_app_update({ state in
        Game.current.update()
      })
      render()
    }
  }

  func update() {
    cf_app_get_size(&width, &height)
    sceneManager.update()
  }

  func render() {
    cf_draw_scale_v2(scaleV2)
    sceneManager.render()
    self.drawCount = cf_app_draw_onto_screen(true)
  }

  deinit {
    sceneManager.unloadAll()
    cf_destroy_app()
  }
}
