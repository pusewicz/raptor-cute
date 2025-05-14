import CPicoECS

extension ECS {
  @discardableResult
  public func createEntity() -> EntityID {
    ecs_create(ecs)
  }
}
