extension CF_V2 {
  init(_ x: Float, _ y: Float) {
    self.init(x: x, y: y)
  }

  static func + (left: CF_V2, right: CF_V2) -> CF_V2 {
    CF_V2(left.x + right.x, left.y + right.y)
  }

  static func += (left: inout CF_V2, right: CF_V2) {
    left = left + right
  }

  static func - (left: CF_V2, right: CF_V2) -> CF_V2 {
    CF_V2(left.x - right.x, left.y - right.y)
  }

  static func -= (left: inout CF_V2, right: CF_V2) {
    left = left - right
  }

  static func * (left: CF_V2, right: CF_V2) -> CF_V2 {
    CF_V2(left.x * right.x, left.y * right.y)
  }

  static func * (left: CF_V2, right: Float) -> CF_V2 {
    CF_V2(left.x * right, left.y * right)
  }

  static func * (left: Float, right: CF_V2) -> CF_V2 {
    CF_V2(left * right.x, left * right.y)
  }

  static func *= (left: inout CF_V2, right: CF_V2) {
    left = left * right
  }

  static func / (left: CF_V2, right: CF_V2) -> CF_V2 {
    CF_V2(left.x / right.x, left.y / right.y)
  }

  static func / (left: CF_V2, right: Float) -> CF_V2 {
    CF_V2(left.x / right, left.y / right)
  }

  static func /= (left: inout CF_V2, right: CF_V2) {
    left = left / right
  }

  static func /= (left: inout CF_V2, right: Float) {
    left = left / right
  }

  static prefix func - (v: CF_V2) -> CF_V2 {
    CF_V2(-v.x, -v.y)
  }

  static func > (left: CF_V2, right: CF_V2) -> Bool {
    left.x > right.x && left.y > right.y
  }

  static func < (left: CF_V2, right: CF_V2) -> Bool {
    left.x < right.x && left.y < right.y
  }

  static func >= (left: CF_V2, right: CF_V2) -> Bool {
    left.x >= right.x && left.y >= right.y
  }

  static func <= (left: CF_V2, right: CF_V2) -> Bool {
    left.x <= right.x && left.y <= right.y
  }

}
