import CPicoECS

public class ECS {
  public typealias ReturnCode = ecs_ret_t
  public typealias EntityID = ecs_id_t
  public typealias ComponentID = ecs_id_t
  public typealias SystemID = ecs_id_t
  public typealias TimeInterval = Float

  public var ecs: OpaquePointer
  nonisolated(unsafe) static weak var current: ECS!

  // Dictionary to store component type information
  public var componentIDs: [String: ComponentID] = [:]
  public var systemIDs: [String: SystemID] = [:]

  init(entityCount: Int = 1024) {
    self.ecs = ecs_new(entityCount, nil)

    ECS.current = self
  }

  deinit {
    ecs_free(ecs)
  }

  public func reset() {
    ecs_reset(ecs)
  }
}
