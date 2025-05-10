import CCute

class Game {
  nonisolated(unsafe) static weak var current: Game!

  let screenSize: Int32 = 64 * 2
  let scale: Float = 4
  let scaleV2: CF_V2

  var state: State!
  var background: CF_Sprite!

  init() {
    scaleV2 = CF_V2(x: scale, y: scale)

    let options: CF_AppOptionFlags = Int32(CF_APP_OPTIONS_WINDOW_POS_CENTERED_BIT.rawValue)

    let result = cf_make_app(
      "Raptor", 0, 0, 0, screenSize * Int32(scale), screenSize * Int32(scale), options,
      CommandLine.unsafeArgv[0])

    guard !cf_is_error(result) else {
      fatalError("Could not make app")
    }

    cf_app_set_vsync(true)
    cf_set_target_framerate(60)
    cf_set_fixed_timestep(60)
    cf_set_fixed_timestep_max_updates(5)

    mountContentDirectory(as: "content/")

    state = State(player: Player())
    background = CF_Sprite.fromAseprite(path: "content/background.aseprite")

    Game.current = self
  }

  func mountContentDirectory(as dest: String) {
    guard let base = cf_fs_get_base_directory() else {
      fatalError("Could not get base directoy")
    }
    var path = String(cString: base)
    path += "content"
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
    updatePlayer()
    updatePlayerBeams()
    cf_sprite_update(&background)
  }

  func updatePlayer() {
    state.player.update()
    if state.player.didShoot {
      let position = CF_V2(x: state.player.position.x, y: state.player.position.y + 2)
      state.playerBeams.append(PlayerBeam(at: position))
    }
  }

  func updatePlayerBeams() {
    for i in state.playerBeams.indices {
      state.playerBeams[i].update()

      // Mark beam as destroyed when out of bounds
      if state.playerBeams[i].position.y > 64 + 8 {
        state.playerBeams[i].destroy()
      }
    }

    // Remove destroyed beams
    state.playerBeams.removeAll(where: { $0.isDestroyed })
  }

  func render() {
    cf_draw_push()
    cf_draw_scale_v2(scaleV2)

    renderBackground()
    renderPlayerBeams()
    state.player.draw()

    cf_draw_pop()
    cf_app_draw_onto_screen(true)
  }

  func renderBackground() {
    for x in [-1, 1] {
      for y in [-1, 1] {
        cf_draw_push()
        cf_draw_translate(Float(32 * x), Float(32 * y))
        background.draw()
        cf_draw_pop()
      }
    }
  }

  func renderPlayerBeams() {
    for i in state.playerBeams.indices {
      state.playerBeams[i].draw()
    }
  }

  deinit {
    cf_destroy_app()
  }
}
