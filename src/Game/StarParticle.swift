import CuteFramework

struct StarParticle {
  let speed: Float
  let size: Float
  var position: CF_V2
  private(set) var isDestroyed = false

  init(canvasWidth: Float) {
    self.position = CF_V2(
      x: Float.random(in: -(canvasWidth / 2)...(canvasWidth / 2)),
      y: Float.random(in: -10.0...0.0) + canvasWidth / 2
    )
    self.speed = Float.random(in: 0.1...0.5)
    self.size = speed * 2.0
  }

  mutating func update() {
    position.y -= speed
  }

  func draw() {
    cf_draw_push()
    cf_draw_push_color(cf_color_white())
    cf_draw_translate(position.x, position.y)
    cf_draw_quad_fill(cf_make_aabb_pos_w_h(position, size, size), 0.0)
    cf_draw_pop_color()
    cf_draw_pop()
  }

  mutating func destroy() {
    self.isDestroyed = true
  }
}
