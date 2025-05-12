import CCute

enum EnemyType: CustomStringConvertible, CaseIterable {
  case alan
  case bonBon
  case lips

  var description: String {
    switch self {
    case .alan: return "alan"
    case .bonBon: return "bon_bon"
    case .lips: return "lips"
    }
  }

  var boundsFactor: CF_V2 {
    switch self {
    case .alan: return CF_V2(x: 0, y: -1)
    case .bonBon: return CF_V2(x: -1, y: -4)
    case .lips: return CF_V2(x: -2, y: -3)
    }
  }

  /// Fetch random enemy type
  static func random() -> EnemyType {
    let allTypes = EnemyType.allCases
    let randomIndex = Int(arc4random_uniform(UInt32(allTypes.count)))
    return allTypes[randomIndex]
  }
}

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
