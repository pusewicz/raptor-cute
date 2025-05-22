import CuteFramework

struct Enemy {
  private(set) var position: CF_V2
  var sprite: CF_Sprite
  let speed: Float
  private(set) var isDestroyed = false
  let type: EnemyType

  var bounds: CF_Aabb {
    cf_expand_aabb(
      cf_make_aabb_pos_w_h(
        position,
        Float(sprite.w),
        Float(sprite.h)
      ), type.boundsFactor)
  }

  init(at position: CF_V2, speed: Float = 0.1, type: EnemyType = EnemyType.random()) {
    self.position = position
    self.speed = speed
    self.sprite = CF_Sprite.fromAseprite(path: "sprites/\(type.description).ase")
    self.type = type
  }

  // Updates the beam's position
  mutating func update() {
    position.y -= speed
    sprite.update()
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
}
