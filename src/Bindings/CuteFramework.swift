@_exported @preconcurrency import CCuteFramework

extension CF_Audio {
  /// Create an audio from a OGG file
  public static func fromOGG(path: String) -> CF_Audio {
    return cf_audio_load_ogg(path)
  }
}

extension CF_V2 {
  public init(x: Int32, y: Int32) {
    self.init(x: Float(x), y: Float(y))
  }

  public init(x: Int, y: Int) {
    self.init(x: Float(x), y: Float(y))
  }

  public static func + (left: CF_V2, right: CF_V2) -> CF_V2 {
    CF_V2(x: left.x + right.x, y: left.y + right.y)
  }

  public static func += (left: inout CF_V2, right: CF_V2) {
    left = left + right
  }

  public static func - (left: CF_V2, right: CF_V2) -> CF_V2 {
    CF_V2(x: left.x - right.x, y: left.y - right.y)
  }

  public static func -= (left: inout CF_V2, right: CF_V2) {
    left = left - right
  }

  public static func * (left: CF_V2, right: CF_V2) -> CF_V2 {
    CF_V2(x: left.x * right.x, y: left.y * right.y)
  }

  public static func * (left: CF_V2, right: Float) -> CF_V2 {
    CF_V2(x: left.x * right, y: left.y * right)
  }

  public static func * (left: Float, right: CF_V2) -> CF_V2 {
    CF_V2(x: left * right.x, y: left * right.y)
  }

  public static func *= (left: inout CF_V2, right: CF_V2) {
    left = left * right
  }

  public static func / (left: CF_V2, right: CF_V2) -> CF_V2 {
    CF_V2(x: left.x / right.x, y: left.y / right.y)
  }

  public static func / (left: CF_V2, right: Float) -> CF_V2 {
    CF_V2(x: left.x / right, y: left.y / right)
  }

  public static func /= (left: inout CF_V2, right: CF_V2) {
    left = left / right
  }

  public static func /= (left: inout CF_V2, right: Float) {
    left = left / right
  }

  public static prefix func - (v: CF_V2) -> CF_V2 {
    CF_V2(x: -v.x, y: -v.y)
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

extension CF_Sprite: @unchecked @retroactive Sendable {
  /// Get the bounding rectangle of the sprite
  var bounds: CF_Rect {
    return CF_Rect(x: 0, y: 0, w: w, h: h)
  }

  /// Update the sprite's animation
  public mutating func update() { cf_sprite_update(&self) }

  /// Play a specific animation from the beginning
  public mutating func play(animation: String) {
    cf_sprite_play(&self, animation)
  }

  /// Check if a specific animation is currently playing
  public mutating func isPlaying(animation: String) -> Bool {
    withUnsafeMutablePointer(to: &self) { pointer in

    cf_sprite_is_playing(pointer, animation)
    }
  }

  /// Draw the sprite
  public mutating func draw() { cf_draw_sprite(&self) }

  /// Returns true if the animation will loop around and finish if cf_sprite_update is called.
  public mutating func willFinish() -> Bool { cf_sprite_will_finish(&self) }
}

extension CF_Sprite {
  /// Create a sprite from a PNG file
  public static func fromPNG(path: String) -> CF_Sprite {
    var result = CF_Result()
    return cf_make_easy_sprite_from_png(path, &result)
  }

  /// Create a sprite from an Aseprite file
  public static func fromAseprite(path: String) -> CF_Sprite {
    return cf_make_sprite(path)
  }
}
