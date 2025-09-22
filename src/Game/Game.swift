import CuteFramework

@MainActor
public final class Game {
  nonisolated(unsafe) static weak var current: Game!

  let screenSize: Int32 = 64 * 3
  let scale: Int32 = 4
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

  // Scene Management
  let sceneManager = SceneManager()

  public init() async {
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

    cf_app_init_imgui()

    mountAssetsDirectory(as: "/")
    cf_shader_directory("/assets/shaders")

    let shader = cf_make_draw_shader("noop.shd")
    guard shader.id != 0 else {
      fatalError("Could not create shader")
    }

    // Load the default font
    loadFont("assets/fonts/tiny-and-chunky.ttf", "TinyAndChunky")
    self.state = State(
      player: Player(),
      shader: shader,
      canvas: cf_make_canvas(cf_canvas_defaults(width, height))
    )

    Game.current = self

    // Register scenes
    let mainMenuScene = MainMenuScene(game: self)
    let gameplayScene = GameplayScene(game: self)
    let gameOverScene = GameOverScene(game: self)

    sceneManager.register(scene: mainMenuScene, for: .mainMenu)
    sceneManager.register(scene: gameplayScene, for: .gamePlay)
    sceneManager.register(scene: gameOverScene, for: .gameOver)

    // Load scenes
    sceneManager.loadScene(.mainMenu)
    sceneManager.loadScene(.gamePlay)
    sceneManager.loadScene(.gameOver)

    // Start with main menu
    await sceneManager.switchTo(.mainMenu)
  }

  func mountAssetsDirectory(as dest: String) {
    guard let base = cf_fs_get_base_directory() else {
      fatalError("Could not get base directoy")
    }
    var path = String(cString: base)
    path += "assets"
    cf_fs_mount(path, dest, false)
  }

  public func run() async {
    while cf_app_is_running() {
      cf_app_update(nil)
      await Game.current.update()
      render()
    }
  }

  func update() async {
    cf_app_get_size(&width, &height)
    await sceneManager.update()
  }

  func render() {
    cf_draw_push()
    cf_draw_scale(Float(scale), Float(scale))
    sceneManager.render()
    cf_draw_pop()

    if !state.debug {
      cf_render_to(state.canvas, true)

      cf_draw_push_shader(state.shader)
      cf_draw_set_texture("canvas_tex", cf_canvas_get_target(state.canvas))
      cf_draw_box(
        cf_make_aabb(CF_V2(-128 * scale, -128 * scale), CF_V2(128 * scale, 128 * scale)), 3, 1)
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
    // sceneManager.unloadAll()
    cf_destroy_shader(state.shader)
    cf_destroy_app()
  }
}
