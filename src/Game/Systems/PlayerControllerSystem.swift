import CuteFramework
import Engine

struct PlayerControllerSystem: ECS.System {
  var enabled = true
  var priority = 100

  func update(_ ecs: ECS, deltaTime: ECS.TimeInterval) {
    for (entity, _, _) in ecs.entitiesWith(PlayerController.self, Velocity.self) {
      var newVelocity = Velocity(x: 0, y: 0)
      if cf_key_down(CF_KEY_W) {
        newVelocity.y = 1
      }
      if cf_key_down(CF_KEY_S) {
        newVelocity.y = -1
      }
      if cf_key_down(CF_KEY_A) {
        newVelocity.x = -1
      }
      if cf_key_down(CF_KEY_D) {
        newVelocity.x = 1
      }
      ecs.addComponent(newVelocity, to: entity)
    }
  }
}
