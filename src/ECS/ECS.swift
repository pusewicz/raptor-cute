import CPicoECS

class ECS {
  public typealias ReturnCode = ecs_ret_t
  public typealias EntityID = ecs_id_t
  public typealias ComponentID = ecs_id_t
  public typealias SystemID = ecs_id_t
  public typealias TimeInterval = Float

  private var ecs: OpaquePointer
  nonisolated(unsafe) static weak var current: ECS!

  /// Hashmap of systems
  private var systems: [SystemID: System] = [:]

  /// Initialize a new ECS instance
  /// - Parameter entityCount: Initial capacity for pooled entities
  init(entityCount: Int = 1024) {
    self.ecs = ecs_new(entityCount, nil)

    ECS.current = self
  }

  deinit {
    ecs_free(ecs)
  }

  /// Reset the ECS instance, removing all entities while preserving systems and components
  public func reset() {
    ecs_reset(ecs)
  }
}

/// MARK: Entities
extension ECS {
  @discardableResult
  public func createEntity() -> EntityID {
    ecs_create(ecs)
  }
}

/// MARK: Components
extension ECS {
  @discardableResult
  public func registerComponent<T>(_ component: T.Type) -> ComponentID {
    ecs_register_component(ecs, MemoryLayout<T>.size, nil, nil)
  }
}

/// MARK: Systems
extension ECS {
  private class SystemContext {
    let system: System
    let ecs: ECS

    init(ecs: ECS, system: System) {
      self.ecs = ecs
      self.system = system
    }
  }

  protocol System {
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
    systems[systemId] = system
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
