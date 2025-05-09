import Cute

struct PlayerBeam {
  private(set) var position: CF_V2
  var sprite: CF_Sprite
  var speed: Float = 3
  private(set) var isDestroyed = false

  init(at position: CF_V2) {
    self.position = position
    sprite = cf_make_sprite("content/player_beam.aseprite")
  }

  mutating func update() {
    position.y += speed
  }

  mutating func destroy() {
    isDestroyed = true
  }

  func draw() {
    var sprite = sprite
    cf_draw_push()
    cf_draw_translate_v2(position)
    cf_sprite_draw(&sprite)
    cf_draw_pop()
  }
}
