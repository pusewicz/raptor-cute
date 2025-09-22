import Engine

struct MovementSystem: ECS.System {
  var enabled = true
  var priority = 100

  func update(_ ecs: ECS, deltaTime: ECS.TimeInterval) {
    for (entity, position, velocity) in ecs.entitiesWith(Position.self, Velocity.self) {
      let newPosition = Position(x: position.x + velocity.x, y: position.y + velocity.y)
      ecs.addComponent(newPosition, to: entity)
    }
  }
}
