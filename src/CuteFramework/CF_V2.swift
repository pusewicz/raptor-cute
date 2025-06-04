extension CF_V2 {
  public init(_ x: Float, _ y: Float) {
    self.init(x: x, y: y)
  }

  public init(_ x: Int32, _ y: Int32) {
    self.init(x: Float(x), y: Float(y))
  }

  public init(_ x: Int, _ y: Int) {
    self.init(x: Float(x), y: Float(y))
  }

  public static func + (left: CF_V2, right: CF_V2) -> CF_V2 {
    CF_V2(left.x + right.x, left.y + right.y)
  }

  public static func += (left: inout CF_V2, right: CF_V2) {
    left = left + right
  }

  public static func - (left: CF_V2, right: CF_V2) -> CF_V2 {
    CF_V2(left.x - right.x, left.y - right.y)
  }

  public static func -= (left: inout CF_V2, right: CF_V2) {
    left = left - right
  }

  public static func * (left: CF_V2, right: CF_V2) -> CF_V2 {
    CF_V2(left.x * right.x, left.y * right.y)
  }

  public static func * (left: CF_V2, right: Float) -> CF_V2 {
    CF_V2(left.x * right, left.y * right)
  }

  public static func * (left: Float, right: CF_V2) -> CF_V2 {
    CF_V2(left * right.x, left * right.y)
  }

  public static func *= (left: inout CF_V2, right: CF_V2) {
    left = left * right
  }

  public static func / (left: CF_V2, right: CF_V2) -> CF_V2 {
    CF_V2(left.x / right.x, left.y / right.y)
  }

  public static func / (left: CF_V2, right: Float) -> CF_V2 {
    CF_V2(left.x / right, left.y / right)
  }

  public static func /= (left: inout CF_V2, right: CF_V2) {
    left = left / right
  }

  public static func /= (left: inout CF_V2, right: Float) {
    left = left / right
  }

  public static prefix func - (v: CF_V2) -> CF_V2 {
    CF_V2(-v.x, -v.y)
  }

  public static func > (left: CF_V2, right: CF_V2) -> Bool {
    left.x > right.x && left.y > right.y
  }

  public static func < (left: CF_V2, right: CF_V2) -> Bool {
    left.x < right.x && left.y < right.y
  }

  public static func >= (left: CF_V2, right: CF_V2) -> Bool {
    left.x >= right.x && left.y >= right.y
  }

  public static func <= (left: CF_V2, right: CF_V2) -> Bool {
    left.x <= right.x && left.y <= right.y
  }

}
