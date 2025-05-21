import CuteFramework

struct Explosion {
  private(set) var position: CF_V2
  var sprite: CF_Sprite
  private(set) var isDestroyed = false

  init(at position: CF_V2) {
    self.position = position
    self.sprite = CF_Sprite.fromAseprite(path: "content/explosion.aseprite")
  }

  mutating func update() {
    sprite.update()
    if sprite.willFinish() {
      self.isDestroyed = true
    }
  }

  mutating func draw() {
    cf_draw_push()
    cf_draw_translate_v2(position)
    sprite.draw()
    cf_draw_pop()
  }
}
