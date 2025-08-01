import CuteFramework

class Game {
  nonisolated(unsafe) static weak var current: Game!

  let screenSize: Int32 = 64 * 3
  let scale: Int32 = 4
  let scaleV2: CF_V2
  var state: State!

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

  var shader: CF_Shader!
  var canvas: CF_Canvas!

  // Scene Management
  let sceneManager = SceneManager()

  init() {
    self.scaleV2 = V2(scale, scale)

    let options: CF_AppOptionFlags = Int32(CF_APP_OPTIONS_WINDOW_POS_CENTERED_BIT.rawValue)

    print("Creating Raptor game...")
    print(
      "Screen size: logical(\(screenSize) x \(screenSize)), physical(\(screenSize * scale) x \(screenSize * scale))"
    )

    // Make app
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
    cf_shader_directory("/assets/shaders")

    let shader = cf_make_draw_shader("noop.shd")
    guard shader.id != 0 else {
      fatalError("Could not create shader")
    }
    self.shader = shader

    self.canvas = cf_make_canvas(cf_canvas_defaults(width, height))

    // Load the default font
    loadFont("assets/fonts/tiny-and-chunky.ttf", "TinyAndChunky")
    self.state = State(player: Player())

    Game.current = self

    // Register scenes
    let mainMenuScene = MainMenuScene(game: self)
    let gameplayScene = GameplayScene(game: self)

    sceneManager.register(scene: mainMenuScene, for: .mainMenu)
    sceneManager.register(scene: gameplayScene, for: .gameplay)

    // Load scenes
    sceneManager.loadScene(.mainMenu)
    sceneManager.loadScene(.gameplay)

    // Start with main menu
    sceneManager.switchTo(.mainMenu)
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
    cf_draw_push()
    cf_draw_scale_v2(scaleV2)
    sceneManager.render()
    cf_draw_pop()

    if !state.debug {
      cf_render_to(canvas, true)

      cf_draw_push_shader(shader)
      cf_draw_set_texture("canvas_tex", cf_canvas_get_target(canvas))
      cf_draw_box(
        cf_make_aabb(V2(-128 * scale, -128 * scale), V2(128 * scale, 128 * scale)), 3, 1)
    }
    self.drawCount = cf_app_draw_onto_screen(false)
  }

  func loadFont(_ path: String, _ name: String) {
    let font = cf_make_font(path, name)
    guard !cf_is_error(font) else {
      fatalError("Could not load font at \(path)")
    }
  }

  deinit {
    sceneManager.unloadAll()
    if let shader {
      cf_destroy_shader(shader)
    }
    cf_destroy_app()
  }
}
