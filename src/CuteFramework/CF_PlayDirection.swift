import CCuteFramework

extension CF_PlayDirection: @retroactive CustomStringConvertible {
  public var description: String {
    switch self {
    case CF_PLAY_DIRECTION_FORWARDS:
      return "Forwards"
    case CF_PLAY_DIRECTION_BACKWARDS:
      return "Backwards"
    case CF_PLAY_DIRECTION_PINGPONG:
      return "PingPong"
    default:
      return "Unknown"
    }
  }
}
