import CuteFramework

struct Enemy {
  private(set) var position: CF_V2
  var sprite: CF_Sprite
  let speed: Float
  private(set) var isDestroyed = false
  let type: EnemyType

  // The bezier curve is used to control the enemy's movement
  var bezier: CubicBezierLine

  // The t variable is used to control the position along the bezier curve
  var t: Float = 0

  var bounds: CF_Aabb {
    cf_expand_aabb(
      cf_make_aabb_pos_w_h(
        position,
        Float(sprite.w),
        Float(sprite.h)
      ), type.boundsFactor)
  }

  init(
    at position: CF_V2, playerPosition: CF_V2, speed: Float = 0.1,
    type: EnemyType = EnemyType.random()
  ) {
    self.bezier = CubicBezierLine(
      a: position,
      c0: CF_V2(x: -72, y: 32),
      c1: CF_V2(x: 72, y :-16),
      b: playerPosition,
      iters: 24,
      thickness: 1
    )
    self.position = position
    self.speed = speed
    self.sprite = CF_Sprite.fromAseprite(path: "sprites/\(type.description).ase")
    self.type = type

  }

  mutating func update(state: State) {
    let t = cf_clamp(t / 512, 0, 512)
    self.position = cf_bezier2(
      bezier.a,
      bezier.c0,
      bezier.c1,
      bezier.b,
      t
    )
    sprite.update()
    self.t += 1
  }

  // Marks the beam for destruction when it's out of bounds
  mutating func destroy() {
    isDestroyed = true
  }

  @MainActor
  mutating func draw(state: State) {
    cf_draw_push()
    if state.debug {
      cf_draw_bezier_line2(bezier.a, bezier.c0, bezier.c1, bezier.b, bezier.iters, bezier.thickness)
    }
    cf_draw_translate_v2(position)
    sprite.draw()
    cf_draw_pop()
  }

  struct CubicBezierLine {
    var a: CF_V2
    var c0: CF_V2
    var c1: CF_V2
    var b: CF_V2
    var iters: Int32
    var thickness: Float = 0.0
  }
}
