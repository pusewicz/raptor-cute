import CuteFramework
import Foundation

class GameplayScene: Scene {
  private weak var game: Game!
  private var state: State {
    get {
      game.state
    }
    set {
      game.state = newValue
    }
  }
  private var background: Background!
  private var stars: [StarParticle] = []
  private var sounds: [String: CF_Audio] = [:]
  private var music: CF_Audio?
  private var lifeIcon: CF_Sprite!

  private var fontSize: Float = 7
  private var score = 0

  var scale: Int32 {
    game.scale
  }

  var screenSize: Int32 {
    game.screenSize
  }

  init(game: Game) {
    self.game = game
  }

  func load() {
    self.sounds["fire_sound"] = CF_Audio.fromOGG(path: "sounds/fire_6.ogg")
    self.sounds["explosion_sound"] = CF_Audio.fromOGG(path: "sounds/8bit_expl_short_00.ogg")
    self.music = CF_Audio.fromOGG(path: "music/Zero Respect.ogg")
    self.lifeIcon = loadPng("assets/sprites/life.png")
  }

  func loadPng(_ path: String) -> CF_Sprite {
    var result = CF_Result()
    let sprite = cf_make_easy_sprite_from_png(path, &result)
    guard !cf_is_error(result) else {
      fatalError("Could not load sprite from \(path): \(String(cString: result.details))")
    }
    return sprite
  }

  func enter() {
    // Initialize game state
    background = Background()
    score = 0

    // Spawn initial enemies
    spawnMonsters(amount: 2)

    // Spawn initial stars
    for _ in 0..<10 {
      stars.append(makeStar())
    }

    // Play gameplay music
    if let music {
      cf_music_play(music, 3)
    }
  }

  func exit() {
    // Stop music
    cf_music_stop(0.5)

    // Clear game state
    state = State(player: Player())
    background = nil
    stars.removeAll()
  }

  func unload() {
    // Unload sounds
    for sound in sounds.values {
      cf_audio_destroy(sound)
    }

    if let music {
      cf_audio_destroy(music)
    }
  }

  func handleInput() {
    guard let game = game else { return }

    if cf_key_just_pressed(CF_KEY_G) {
      state.debug = !state.debug
    }

    if cf_key_just_pressed(CF_KEY_ESCAPE) {
      // Return to main menu
      game.sceneManager.switchTo(.mainMenu)
      return
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

  func update() {
    guard game != nil else { return }

    cf_sprite_update(&lifeIcon)

    // Spawn enemies periodically
    if cf_on_interval(4, 0) {
      let randomNumber = Int32.random(in: 1...3)
      spawnMonsters(amount: randomNumber)
    }

    // Spawn stars periodically
    if cf_on_interval(0.5, 0) {
      stars.append(makeStar())
    }

    // Update game objects
    updatePlayer()
    updatePlayerBeams()
    updateEnemies()
    updateExplosions()
    updateStars()
    background.update()

    checkCollisions()

    // Remove destroyed objects
    state.playerBeams.removeAll(where: { $0.isDestroyed })
    state.enemies.removeAll(where: { $0.isDestroyed })
    state.explosions.removeAll(where: { $0.isDestroyed })

    // Update window title
    updateWindowTitle()
  }

  func render() {
    cf_draw_push()

    renderBackground()
    renderStars()
    renderPlayerBeams()
    renderEnemies()
    renderExplosions()
    state.player.draw()

    renderUI()

    if state.debug {
      renderDebug()
    }

    cf_draw_pop()
  }

  // MARK: - Private Methods

  private func spawnMonsters(amount: Int32) {
    guard let game = game else { return }
    let halfWidth = game.canvasWidth / 2
    let offset = halfWidth / amount
    for i in 0..<amount {
      let position = V2(
        x: (Float(i) * Float(16 + 4)) - Float(offset),
        y: Float(game.canvasHeight / 2) - 32
      )
      state.enemies.append(Enemy(at: position, playerPosition: state.player.position))
    }
  }

  private func makeStar() -> StarParticle {
    guard let game = game else {
      return StarParticle(canvasWidth: 192)
    }
    return StarParticle(canvasWidth: Float(game.canvasWidth))
  }

  private func updatePlayer() {
    if state.player.didShoot() {
      let position = CF_V2(x: state.player.position.x, y: state.player.position.y + 2)
      state.playerBeams.append(PlayerBeam(at: position))

      if let fireSound = sounds["fire_sound"] {
        cf_play_sound(fireSound, cf_sound_params_defaults())
      }
    }

    state.player.update()
  }

  private func updatePlayerBeams() {
    guard let game = game else { return }
    for i in state.playerBeams.indices {
      state.playerBeams[i].update()

      // Mark beam as destroyed when out of bounds
      if state.playerBeams[i].position.y > Float(game.canvasHeight / 2) + 8 {
        state.playerBeams[i].destroy()
      }
    }
  }

  private func updateEnemies() {
    guard let game = game else { return }
    for i in state.enemies.indices {
      state.enemies[i].update(state: self.state)

      // Mark enemy as destroyed when out of bounds
      if state.enemies[i].position.y < Float(-game.canvasHeight / 2) - 8 {
        state.enemies[i].destroy()
      }
    }
  }

  private func updateExplosions() {
    for i in state.explosions.indices {
      state.explosions[i].update()
    }
  }

  private func updateStars() {
    guard let game = game else { return }
    for i in stars.indices {
      stars[i].update()
      if stars[i].position.y < Float(-game.canvasHeight / 2) {
        stars[i].destroy()
      }
    }
    stars.removeAll(where: { $0.isDestroyed })
  }

  private func checkCollisions() {
    for i in state.playerBeams.indices {
      for j in state.enemies.indices {
        if state.playerBeams[i].collides(with: state.enemies[j]) {
          state.playerBeams[i].destroy()
          state.enemies[j].destroy()

          self.score += 100

          // Add an explosion
          state.explosions.append(Explosion(at: state.enemies[j].position))

          if let explosionSound = sounds["explosion_sound"] {
            cf_play_sound(explosionSound, cf_sound_params_defaults())
          }
        }
      }
    }
  }

  private func updateWindowTitle() {
    var name = "Raptor"
    if state.debug {
      name = "Raptor (Debug)"
    }

    let fps = cf_app_get_smoothed_framerate().rounded()
    let title =
      "\(name) - \(state.player.position.x), \(state.player.position.y), Enemies: \(state.enemies.count), Beams: \(state.playerBeams.count), Explosions: \(state.explosions.count), FPS: \(fps)"
    cf_app_set_title(title)
  }

  // MARK: - Rendering Methods

  private func renderBackground() {
    background.draw()
  }

  private func renderStars() {
    for star in stars {
      star.draw()
    }
  }

  private func renderPlayerBeams() {
    for i in state.playerBeams.indices {
      state.playerBeams[i].draw()
    }
  }

  private func renderEnemies() {
    for i in state.enemies.indices {
      state.enemies[i].draw(state: state)
    }
  }

  private func renderExplosions() {
    for i in state.explosions.indices {
      state.explosions[i].draw()
    }
  }

  private func renderUI() {
    /**
     * Render score
     */
    cf_push_font("TinyAndChunky")
    cf_push_font_size(self.fontSize)
    let scoreText = String(format: "%06d", score)
    let textWidth = cf_text_width(scoreText, -1)
    let textHeight = cf_text_height(scoreText, -1)

    cf_draw_push_color(cf_make_color_rgb(20, 91, 132))
    cf_draw_text(
      scoreText,
      V2(
        screenSize / 2 * scale - Int32(textWidth) * scale - 16,
        screenSize / 2 * scale - Int32(textHeight) * scale - 24
      ),
      -1)
    cf_draw_push_color(cf_color_white())
    cf_draw_text(
      scoreText,
      V2(
        screenSize / 2 * scale - Int32(textWidth) * scale - 20,
        screenSize / 2 * scale - Int32(textHeight) * scale - 20
      ),
      -1)

    cf_pop_font()

    /**
     * Render player lives
     */

    let lives = state.lives

    let lifeIconSize = Int32(16)
    let lifeIconOffset = Int32(0)
    for i in 0..<lives {
      let x = Int32(screenSize / 2 - 44 + Int32(i) * lifeIconSize)
      let y = Int32(-screenSize / 2 + lifeIconOffset + Int32(lifeIconSize) / 2 + 4)
      cf_draw_push()
      cf_draw_translate_v2(V2(x, y))
      cf_draw_sprite(&lifeIcon)
      cf_draw_pop()
    }
  }

  private func renderDebug() {
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
}
