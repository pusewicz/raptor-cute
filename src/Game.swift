import CCute

class Game {
  nonisolated(unsafe) static weak var current: Game!

  let screenSize: Int32 = 64 * 3
  let scale: Int32 = 4
  let scaleV2: CF_V2

  var state: State!
  var background: CF_Sprite!
  var fireSound: CF_Audio!

  /// Screen width and height
  var width: Int32 = 0
  var height: Int32 = 0

  var canvasWidth: Int32 {
    return width / scale
  }

  var canvasHeight: Int32 {
    return height / scale
  }

  init() {
    scaleV2 = CF_V2(x: Float(scale), y: Float(scale))

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

    mountContentDirectory(as: "content/")

    state = State(player: Player())

    /// Add 3 enemies in a row
    for i in [-1, 0, 1] {
      let position = CF_V2(x: Float(i) * (16 + 4), y: 64)
      state.enemies.append(Enemy(at: position))
    }

    background = CF_Sprite.fromAseprite(path: "content/background.aseprite")
    fireSound = CF_Audio.fromOGG(path: "content/fire_6.ogg")

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
    cf_app_get_size(&width, &height)

    updatePlayer()
    updatePlayerBeams()
    updateEnemies()

    checkCollisions()

    // Remove destroyed beams
    state.playerBeams.removeAll(where: { $0.isDestroyed })

    // Remove destroyed enemies
    state.enemies.removeAll(where: { $0.isDestroyed })

    background.update()

    let title =
      "Raptor - \(state.player.position.x), \(state.player.position.y), Enemies: \(state.enemies.count), Beams: \(state.playerBeams.count)"
    cf_app_set_title(title)
  }

  func updatePlayer() {
    state.player.update()

    if state.player.didShoot {
      let position = CF_V2(x: state.player.position.x, y: state.player.position.y + 2)
      state.playerBeams.append(PlayerBeam(at: position))

      cf_play_sound(fireSound, cf_sound_params_defaults())
    }
  }

  func updatePlayerBeams() {
    for i in state.playerBeams.indices {
      state.playerBeams[i].update()

      // Mark beam as destroyed when out of bounds
      if state.playerBeams[i].position.y > Float(canvasHeight / 2) + 8 {
        state.playerBeams[i].destroy()
      }
    }
  }

  func updateEnemies() {
    for i in state.enemies.indices {
      state.enemies[i].update()

      // Mark enemy as destroyed when out of bounds
      if state.enemies[i].position.y < Float(-canvasHeight / 2) - 8 {
        state.enemies[i].destroy()
      }
    }
  }

  func checkCollisions() {
    for i in state.playerBeams.indices {
      for j in state.enemies.indices {
        if state.playerBeams[i].collides(with: state.enemies[j]) {
          state.playerBeams[i].destroy()
          state.enemies[j].destroy()
        }
      }
    }
  }

  func render() {
    cf_draw_push()
    cf_draw_scale_v2(scaleV2)

    renderBackground()
    renderPlayerBeams()
    renderEnemies()
    state.player.draw()

    cf_draw_pop()
    cf_app_draw_onto_screen(true)
  }

  func renderBackground() {
    for x in [-1, 0, 1] {
      for y in [-1, 0, 1] {
        cf_draw_push()
        cf_draw_translate(Float(64 * x), Float(64 * y))
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

  func renderEnemies() {
    for i in state.enemies.indices {
      state.enemies[i].draw()
    }
  }

  deinit {
    cf_audio_destroy(fireSound)
    cf_destroy_app()
  }
}
