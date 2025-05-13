import CPicoECS

class ECS {
  private var ecs: OpaquePointer

  init(entityCount: Int = 1024) {
    self.ecs = ecs_new(entityCount, nil)
  }

  public func createEntity() -> ecs_id_t {
    ecs_create(ecs)
  }

  func reset() {
    ecs_reset(ecs)
  }

  deinit {
    ecs_free(ecs)
  }
}
