import CCuteFramework

// MARK: - CF_Sprite Swift Extension
extension CF_Sprite {
  /// Width of the sprite in pixels
  var width: Int32 {
    get { self.w }
    set { self.w = newValue }
  }

  /// Height of the sprite in pixels
  var height: Int32 {
    get { self.h }
    set { self.h = newValue }
  }

  /// Whether or not to pause updates to the animation
  var isPaused: Bool {
    get { self.paused }
    set { self.paused = newValue }
  }

  /// The current play direction
  var playDirection: CF_PlayDirection {
    get { self.play_direction }
    set { self.play_direction = newValue }
  }

  /// Whether or not to loop animations
  var shouldLoop: Bool {
    get { self.loop }
    set { self.loop = newValue }
  }

  /// Get the bounding rectangle of the sprite
  var bounds: CF_Rect {
    return CF_Rect(x: 0, y: 0, w: width, h: height)
  }

  /// Update the sprite's animation
  public mutating func update() { cf_sprite_update(&self) }

  /// Reset the currently playing animation and unpause it
  public mutating func reset() { cf_sprite_reset(&self) }

  /// Play a specific animation from the beginning
  public mutating func play(animation: String) {
    cf_sprite_play(&self, animation)
  }

  /// Check if a specific animation is currently playing
  public mutating func isPlaying(animation: String) -> Bool {
    cf_sprite_is_playing(&self, animation)
  }

  /// Pause the sprite's animation
  public mutating func pause() { cf_sprite_pause(&self) }

  /// Unpause the sprite's animation
  public mutating func unpause() { cf_sprite_unpause(&self) }

  /// Toggle the sprite's paused state
  public mutating func togglePause() { cf_sprite_toggle_pause(&self) }

  /// Flip the sprite on the x-axis
  public mutating func flipX() { cf_sprite_flip_x(&self) }

  /// Flip the sprite on the y-axis
  public mutating func flipY() { cf_sprite_flip_y(&self) }

  /// Draw the sprite
  public mutating func draw() { cf_draw_sprite(&self) }

  /// Reload a sprite's resources
  public mutating func reload() -> CF_Sprite { cf_sprite_reload(&self) }

  /// Returns true if the animation will loop around and finish if cf_sprite_update is called.
  public mutating func willFinish() -> Bool { cf_sprite_will_finish(&self) }
}

// MARK: - Convenience Initializers and Factory Methods
extension CF_Sprite {
  /// Create a default sprite
  static func makeDefault() -> CF_Sprite {
    return cf_sprite_defaults()
  }

  /// Create a sprite from a PNG file
  public static func fromPNG(path: String) -> CF_Sprite {
    var result = CF_Result()
    return cf_make_easy_sprite_from_png(path, &result)
  }

  /// Create a sprite from pixels
  public static func fromPixels(pixels: [CF_Pixel], width: Int, height: Int) -> CF_Sprite {
    return cf_make_easy_sprite_from_pixels(pixels, Int32(width), Int32(height))
  }

  /// Create a sprite from an Aseprite file
  public static func fromAseprite(path: String) -> CF_Sprite {
    return cf_make_sprite(path)
  }

  /// Create a demo sprite for testing
  public static func makeDemo() -> CF_Sprite {
    return cf_make_demo_sprite()
  }
}
