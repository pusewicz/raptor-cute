import CPicoECS

extension ECS {
  @discardableResult
  public func registerComponent<T>(_ componentType: T.Type) -> ComponentID {
    let componentId = ecs_register_component(ecs, MemoryLayout<T>.size, nil, nil)
    componentIDs[String(describing: componentType)] = componentId
    return componentId
  }

  public func requireComponent<S, C>(_ systemType: S.Type, _ componentType: C.Type) {
    let systemName = String(describing: systemType)
    guard let systemID = systemIDs[systemName] else {
      fatalError("System '\(systemName)' not registered")
    }

    let componentName = String(describing: componentType)
    guard let componentID = componentIDs[componentName] else {
      fatalError("Component '\(componentName)' not registered")
    }
    ecs_require_component(ecs, systemID, componentID)
  }
}
