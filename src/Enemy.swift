import CCute

enum EnemyType: CustomStringConvertible {
  case alan
  case bonBon
  case lips

  var description: String {
    switch self {
    case .alan:
      return "alan"
    case .alan: return "alan"
    case .bonBon: return "bon_bon"
    case .lips: return "lips"
    }
  }
}

struct Enemy {
  private(set) var position: CF_V2
  var sprite: CF_Sprite
  let speed: Float
  private(set) var isDestroyed = false
  let type: EnemyType

  var bounds: CF_Aabb {
    cf_make_aabb_pos_w_h(
      position,
      Float(sprite.w),
      Float(sprite.h)
    )
  }

  init(at position: CF_V2, speed: Float = 0.1, type: EnemyType = .alan) {
    self.position = position
    self.speed = speed
    self.sprite = CF_Sprite.fromAseprite(path: "content/\(type.description).aseprite")
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
