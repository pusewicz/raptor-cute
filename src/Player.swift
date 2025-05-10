import CCute

struct Player {
  private(set) var position: CF_V2
  private var shipSprite: CF_Sprite
  private var boosterSprite: CF_Sprite
  private(set) var didShoot = false
  private var shootCooldown = 0

  init() {
    position = CF_V2(x: 0, y: -42)
    shipSprite = CF_Sprite.fromAseprite(path: "content/player_ship.aseprite")
    boosterSprite = CF_Sprite.fromAseprite(path: "content/boosters.aseprite")

    shipSprite.play(animation: "default")
  }

  mutating func update() {
    didShoot = false
    shipSprite.play(animation: "default")

    if cf_key_down(CF_KEY_W) {  // Move up
      position.y += 1
    }
    if cf_key_down(CF_KEY_S) {  // Move down
      position.y -= 1
    }

    if cf_key_down(CF_KEY_A) {  // Move left
      position.x -= 1
      shipSprite.play(animation: "left")
      if !boosterSprite.isPlaying(animation: "left") {
        boosterSprite.play(animation: "left")
      }
    }

    if cf_key_down(CF_KEY_D) {  // Move right
      position.x += 1
      shipSprite.play(animation: "right")
      if !boosterSprite.isPlaying(animation: "right") {
        boosterSprite.play(animation: "right")
      }
    }

    if cf_key_down(CF_KEY_SPACE) && shootCooldown == 0 {
      didShoot = true
      shootCooldown = 8
    }

    if shootCooldown > 0 {
      shootCooldown -= 1
    }

    if !(cf_key_down(CF_KEY_W) || cf_key_down(CF_KEY_S) || cf_key_down(CF_KEY_A)
      || cf_key_down(CF_KEY_D))
    {
      if !boosterSprite.isPlaying(animation: "idle") {
        boosterSprite.play(animation: "idle")
      }
    }

    boosterSprite.update()

    shipSprite.transform.p = position
    boosterSprite.transform.p = position
  }

  mutating func draw() {
    cf_draw_push()
    shipSprite.draw()
    cf_draw_translate(0, -16)
    boosterSprite.draw()
    cf_draw_pop()
  }
}
