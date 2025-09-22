import CuteFramework
import Foundation

class GameOverScene: Scene {
  private weak var game: Game?
  private var gameOverSprite: CF_Sprite?
  private var instructionAlpha: Float = 1.0
  private var fadeDirection: Float = -0.02

  init(game: Game) {
    self.game = game
  }

  func load() {
    self.gameOverSprite = CF_Sprite.fromPNG(path: "sprites/gameover.png")
  }

  func handleInput() async {
    if cf_key_just_pressed(CF_KEY_RETURN) || cf_key_just_pressed(CF_KEY_KP_ENTER) {
      await game?.sceneManager.switchTo(.mainMenu)
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
    gameOverSprite?.update()
  }

  func render() {
    // Draw instruction text with fade effect
    if gameOverSprite != nil {
      cf_draw_push()
      cf_draw_translate(0, -72)
      cf_sprite_set_opacity(&gameOverSprite!, instructionAlpha)
      gameOverSprite?.draw()
      cf_draw_pop()
    }
  }
}
