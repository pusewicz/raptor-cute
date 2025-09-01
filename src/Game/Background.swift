import CuteFramework

struct Background {
  var sprite: CF_Sprite
  var position: CF_V2
  var speed: Float

  init() {
    self.sprite = CF_Sprite.fromAseprite(path: "sprites/background.ase")
    self.position = CF_V2(x: 0, y: 0)
    self.speed = 0.05
  }

  mutating func update() {
    position.y -= speed
    if position.y <= -64 {
      position.y = 0
    }
    sprite.update()
  }

  mutating func draw() {
    for x in [-1, 0, 1] {
      for y in [-1, 0, 1, 2] {
        cf_draw_push()
        cf_draw_translate(64.0 * Float(x) + position.x, 64.0 * Float(y) + position.y)
        sprite.draw()
        cf_draw_pop()
      }
    }
  }
}
