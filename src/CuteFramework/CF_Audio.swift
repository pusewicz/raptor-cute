import CCuteFramework

extension CF_Audio {
  /// Create an audio from a OGG file
  public static func fromOGG(path: String) -> CF_Audio {
    return cf_audio_load_ogg(path)
  }
}
