import CPicoECS

extension ECS {
  private class SystemContext {
    let system: System
    let ecs: ECS

    init(ecs: ECS, system: System) {
      self.ecs = ecs
      self.system = system
    }
  }

  public protocol System {
    @discardableResult
    func update(ecs: ECS, entities: [EntityID], deltaTime: TimeInterval) -> ReturnCode
  }

  @discardableResult
  public func registerSystem<T: System>(_ system: T) -> SystemID {
    let context = SystemContext(ecs: self, system: system)

    // Store context in the heap so it can be accessed from C callbacks
    let contextPointer = Unmanaged<SystemContext>.passRetained(context).toOpaque()

    let systemId = ecs_register_system(
      ecs,
      { (ecs, entities, entityCount, deltaTime, userData) in  // system_cb
        guard let userData = userData else { return -1 }

        let context = Unmanaged<SystemContext>.fromOpaque(userData).takeUnretainedValue()
        let system = context.system
        let entityArray = [EntityID](UnsafeBufferPointer(start: entities, count: Int(entityCount)))
        return system.update(ecs: context.ecs, entities: entityArray, deltaTime: deltaTime)
      },
      nil,  // add_cb
      nil,  // remove_cb
      contextPointer  // udata
    )

    // Store the system in the hashmap
    systemIDs[String(describing: T.self)] = systemId
    return systemId
  }

  @discardableResult
  func updateSystem(_ system: SystemID, deltaTime: TimeInterval) -> ReturnCode {
    ecs_update_system(ecs, system, deltaTime)
  }

  @discardableResult
  func updateSystems(deltaTime: TimeInterval) -> ReturnCode {
    ecs_update_systems(ecs, deltaTime)
  }
}
