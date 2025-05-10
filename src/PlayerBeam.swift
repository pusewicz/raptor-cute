import CCute

struct PlayerBeam {
  private(set) var position: CF_V2
  var sprite: CF_Sprite
  let speed: Float
  private(set) var isDestroyed = false

  init(at position: CF_V2, speed: Float = 3) {
    self.position = position
    self.speed = speed
    self.sprite = cf_make_sprite("content/player_beam.aseprite")
  }

  // Updates the beam's position
  mutating func update() {
    position.y += speed
  }

  // Marks the beam for destruction when it's out of bounds
  mutating func destroy() {
    isDestroyed = true
  }

  mutating func draw() {
    cf_draw_push()
    cf_draw_translate_v2(position)
    cf_sprite_draw(&sprite)
    cf_draw_pop()
  }
}
