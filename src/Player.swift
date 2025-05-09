import Cute

struct Player {
  private(set) var position: CF_V2
  private var shipSprite: CF_Sprite
  private var boosterSprite: CF_Sprite
  private(set) var didShoot = false
  private var shootCooldown = 0

  init() {
    position = CF_V2(x: 0, y: -42)
    shipSprite = cf_make_sprite("content/player_ship.aseprite")
    boosterSprite = cf_make_sprite("content/boosters.aseprite")

    cf_sprite_play(&shipSprite, "default")
  }

  mutating func update() {
    didShoot = false
    cf_sprite_play(&shipSprite, "default")

    if cf_key_down(CF_KEY_W) {  // Move up
      position.y += 1
    }
    if cf_key_down(CF_KEY_S) {  // Move down
      position.y -= 1
    }

    if cf_key_down(CF_KEY_A) {  // Move left
      position.x -= 1
      cf_sprite_play(&shipSprite, "left")
      if !cf_sprite_is_playing(&boosterSprite, "left") {
        cf_sprite_play(&boosterSprite, "left")
      }
    }

    if cf_key_down(CF_KEY_D) {  // Move right
      position.x += 1
      cf_sprite_play(&shipSprite, "right")
      if !cf_sprite_is_playing(&boosterSprite, "right") {
        cf_sprite_play(&boosterSprite, "right")
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
      if !cf_sprite_is_playing(&boosterSprite, "idle") {
        cf_sprite_play(&boosterSprite, "idle")
      }
    }

    cf_sprite_update(&boosterSprite)

    shipSprite.transform.p = position
    boosterSprite.transform.p = position
  }

  func draw() {
    var shipSprite = shipSprite
    var boosterSprite = boosterSprite

    cf_draw_push()
    cf_sprite_draw(&shipSprite)
    cf_draw_translate(0, -16)
    cf_sprite_draw(&boosterSprite)
    cf_draw_pop()
  }
}
