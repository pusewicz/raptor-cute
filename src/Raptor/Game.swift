import CuteFramework

class Game {
  nonisolated(unsafe) static weak var current: Game!

  let screenSize: Int32 = 64 * 3
  let scale: Int32 = 4
  let scaleV2: CF_V2

  var state: State!
  var background: Background!
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

  var drawCount: Int32 = 0
  var stars: [StarParticle] = []

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

    state = State(player: Player())
    spawnMonsters(amount: 2)
    background = Background()
    fireSound = CF_Audio.fromOGG(path: "sounds/fire_6.ogg")

    // Spawn stars
    for _ in 0..<10 {
      stars.append(makeStar())
    }

    Game.current = self
  }

  func spawnMonsters(amount: Int32 = 3) {
    let halfWidth = canvasWidth / 2
    let offset = halfWidth / amount
    for i in 0..<amount {
      let position = CF_V2(
        x: (Float(i) * Float(16 + 4)) - Float(offset), y: Float(canvasHeight / 2))
      state.enemies.append(Enemy(at: position))
    }
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

  func makeStar() -> StarParticle {
    StarParticle(canvasWidth: Float(canvasWidth))
  }

  func update() {
    cf_app_get_size(&width, &height)

    if cf_on_interval(4, 0) {
      let randomNumber = Int32.random(in: 3...12)
      spawnMonsters(amount: randomNumber)
    }

    if cf_on_interval(1, 0) {
      stars.append(makeStar())
    }

    updatePlayer()
    updatePlayerBeams()
    updateEnemies()
    updateExplosions()
    updateStars()

    checkCollisions()

    // Remove destroyed beams
    state.playerBeams.removeAll(where: { $0.isDestroyed })

    // Remove destroyed enemies
    state.enemies.removeAll(where: { $0.isDestroyed })

    // Remove finished explosions
    state.explosions.removeAll(where: { $0.isDestroyed })

    background.update()

    var name = "Raptor"
    if state.debug {
      name = "Raptor (Debug)"
    }

    let fps = cf_app_get_smoothed_framerate().rounded()
    let title =
      "\(name) - \(state.player.position.x), \(state.player.position.y), Enemies: \(state.enemies.count), Beams: \(state.playerBeams.count), Explosions: \(state.explosions.count), FPS: \(fps), Draws: \(drawCount)"
    cf_app_set_title(title)
  }

  func updatePlayer() {
    inputPlayer()

    if state.player.didShoot() {
      let position = CF_V2(x: state.player.position.x, y: state.player.position.y + 2)
      state.playerBeams.append(PlayerBeam(at: position))

      cf_play_sound(fireSound, cf_sound_params_defaults())
    }

    state.player.update()
  }

  func inputPlayer() {
    if cf_key_just_pressed(CF_KEY_G) {
      state.debug = !state.debug
    }

    if cf_key_down(CF_KEY_W) {  // Move up
      state.player.move(.up)
    }
    if cf_key_down(CF_KEY_S) {  // Move down
      state.player.move(.down)
    }

    if cf_key_down(CF_KEY_A) {  // Move left
      state.player.move(.left)
    }

    if cf_key_down(CF_KEY_D) {  // Move right
      state.player.move(.right)
    }

    if cf_key_down(CF_KEY_SPACE) && state.player.canShoot() {
      state.player.shoot()
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

  func updateExplosions() {
    for i in state.explosions.indices {
      state.explosions[i].update()
    }
  }

  func updateStars() {
    for i in stars.indices {
      stars[i].update()
      if stars[i].position.y < Float(-canvasHeight / 2) {
        stars[i].destroy()
      }
    }
    stars.removeAll(where: { $0.isDestroyed })
  }

  func checkCollisions() {
    for i in state.playerBeams.indices {
      for j in state.enemies.indices {
        if state.playerBeams[i].collides(with: state.enemies[j]) {
          state.playerBeams[i].destroy()
          state.enemies[j].destroy()

          /// Add an explosion
          state.explosions.append(Explosion(at: state.enemies[j].position))

          //cf_play_sound(explosionSound, cf_sound_params_defaults())
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
    renderExplosions()
    state.player.draw()
    renderStars()

    if state.debug {
      renderDebug()
    }

    cf_draw_pop()

    self.drawCount = cf_app_draw_onto_screen(true)
  }

  func renderStars() {
    for i in stars.indices {
      stars[i].draw()
    }
  }

  func renderDebug() {
    let red = cf_color_red()
    cf_draw_push_color(red)
    for enemy in state.enemies {
      cf_draw_box(enemy.bounds, 0.1, 0)
    }
    for beam in state.playerBeams {
      cf_draw_box(beam.bounds, 0.1, 0)
    }
    cf_draw_pop_color()
  }

  func renderBackground() {
    background.draw()
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

  func renderExplosions() {
    for i in state.explosions.indices {
      state.explosions[i].draw()
    }
  }

  deinit {
    cf_audio_destroy(fireSound)
    cf_destroy_app()
  }
}
