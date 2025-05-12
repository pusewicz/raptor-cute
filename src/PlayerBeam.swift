import CCute

struct PlayerBeam {
  private(set) var position: CF_V2
  var sprite: CF_Sprite
  let speed: Float
  private(set) var isDestroyed = false

  var bounds: CF_Aabb {
    cf_expand_aabb_f(
      cf_make_aabb_pos_w_h(
        position,
        Float(sprite.w),
        Float(sprite.h)
      ), -3.0)
  }

  init(at position: CF_V2, speed: Float = 3) {
    self.position = position
    self.speed = speed
    self.sprite = CF_Sprite.fromAseprite(path: "content/player_beam.aseprite")
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
    sprite.draw()
    cf_draw_pop()
  }

  mutating func collides(with other: Enemy) -> Bool {
    cf_aabb_to_aabb(self.bounds, other.bounds)
  }
}
