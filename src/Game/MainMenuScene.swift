import CuteFramework

class MainMenuScene: Scene {
  private weak var game: Game?
  private var titleSprite: CF_Sprite?
  private var startSprite: CF_Sprite?
  private var instructionAlpha: Float = 1.0
  private var fadeDirection: Float = -0.02
  private var music: CF_Audio?

  init(game: Game) {
    self.game = game
  }

  func load() {
    self.titleSprite = CF_Sprite.fromAseprite(path: "sprites/intro.ase")
    self.startSprite = CF_Sprite.fromAseprite(path: "sprites/start.ase")
    self.music = CF_Audio.fromOGG(path: "music/Abandoned Hopes.ogg")
  }

  func enter() {
    if let music {
      cf_music_play(music, 0.5)
    }
  }

  func exit() {
    cf_music_stop(0.5)
  }

  func unload() {
    if titleSprite != nil {
      self.titleSprite = nil
      cf_sprite_unload("sprites/intro.ase")
    }

    if startSprite != nil {
      self.startSprite = nil
      cf_sprite_unload("sprites/start.ase")
    }

    if let music {
      self.music = nil
      cf_audio_destroy(music)
    }
  }

  func handleInput() {
    if cf_key_just_pressed(CF_KEY_RETURN) || cf_key_just_pressed(CF_KEY_KP_ENTER) {
      // Switch to gameplay scene
      game?.sceneManager.switchTo(.gamePlay)
    }

    // Allow exit with Escape
    if cf_key_just_pressed(CF_KEY_ESCAPE) {
      cf_app_signal_shutdown()
    }
  }

  func update() {
    // Animate instruction text fade
    instructionAlpha += fadeDirection
    if instructionAlpha <= 0.3 {
      instructionAlpha = 0.3
      fadeDirection = 0.02
    } else if instructionAlpha >= 1.0 {
      instructionAlpha = 1.0
      fadeDirection = -0.02
    }
    titleSprite?.update()
  }

  func render() {
    if titleSprite == nil || startSprite == nil {
      return
    }

    cf_draw_push()

    titleSprite?.draw()

    // Draw instruction text with fade effect
    if startSprite != nil {
      cf_draw_push()
      cf_draw_translate(0, -72)
      cf_sprite_set_opacity(&startSprite!, instructionAlpha)
      startSprite?.draw()
      cf_draw_pop()
    }

    cf_draw_pop()
  }
}
