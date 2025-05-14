@preconcurrency import CCute

class PlayerSystem: ECS.System {
  func update(ecs: ECS, entities: [ECS.EntityID], deltaTime: Float) -> ECS.ReturnCode {
    guard let game = Game.current else {
      return -1
    }

    return 0
  }
}
