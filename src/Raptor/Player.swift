import CuteFramework

let maxShootCooldown = 8

enum MoveDirection {
  case left
  case right
  case up
  case down
}

struct Player {
  private(set) var position: CF_V2
  private var shipSprite: CF_Sprite
  private var boosterSprite: CF_Sprite
  private var shootCooldown = 0
  private var velocity: CF_V2

  init() {
    self.position = V2(0, -42)
    self.shipSprite = CF_Sprite.fromAseprite(path: "sprites/player_ship.ase")
    self.boosterSprite = CF_Sprite.fromAseprite(path: "sprites/boosters.ase")
    self.velocity = V2(0, 0)

    shipSprite.play(animation: "default")
  }

  mutating func move(_ direction: MoveDirection) {
    switch direction {
    case .left: self.velocity.x = -1
    case .right: self.velocity.x = 1
    case .up: self.velocity.y = 1
    case .down: self.velocity.y = -1
    }
  }

  func canShoot() -> Bool {
    shootCooldown == 0
  }

  func didShoot() -> Bool {
    shootCooldown == maxShootCooldown
  }

  mutating func shoot() {
    shootCooldown = maxShootCooldown
  }

  mutating func update() {
    if self.velocity.x > 0 {
      shipSprite.play(animation: "right")
      if !boosterSprite.isPlaying(animation: "right") {
        boosterSprite.play(animation: "right")
      }
    } else if self.velocity.x < 0 {
      shipSprite.play(animation: "left")
      if !boosterSprite.isPlaying(animation: "left") {
        boosterSprite.play(animation: "left")
      }
    } else {
      shipSprite.play(animation: "default")
      if !boosterSprite.isPlaying(animation: "idle") {
        boosterSprite.play(animation: "idle")
      }
    }

    self.position.x += self.velocity.x
    self.position.y += self.velocity.y
    self.velocity.x = 0
    self.velocity.y = 0

    if shootCooldown > 0 {
      shootCooldown -= 1
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
