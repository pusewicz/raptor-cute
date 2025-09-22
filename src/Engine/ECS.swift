public final class ECS {
  public typealias EntityID = UInt32
  public typealias ComponentTypeID = ObjectIdentifier
  public typealias TimeInterval = Float

  public protocol Component {
    static var typeID: ComponentTypeID { get }
  }

  public protocol System {
    func update(_ ecs: ECS, deltaTime: TimeInterval)
    var enabled: Bool { get set }
    var priority: Int { get }
  }

  private var nextEntityID: EntityID = 0
  private var componentStorage: [ComponentTypeID: [EntityID: Any]] = [:]
  private var entityComponents: [EntityID: Set<ComponentTypeID>] = [:]
  private var systems: [System] = []

  public init() {}

  public func createEntity() -> EntityID {
    let entityID = nextEntityID
    nextEntityID += 1
    entityComponents[entityID] = Set()
    return entityID
  }

  public func addComponent<T: Component>(_ component: T, to entity: EntityID) {
    let typeID = T.typeID

    if componentStorage[typeID] == nil {
      componentStorage[typeID] = [:]
    }

    componentStorage[typeID]![entity] = component
    entityComponents[entity]?.insert(typeID)
  }

  public func getComponent<T: Component>(_ type: T.Type, for entity: EntityID) -> T? {
    let typeID = T.typeID
    return componentStorage[typeID]?[entity] as? T
  }

  public func modifyComponent<T: Component>(
    _ type: T.Type, for entity: EntityID, _ modify: (inout T) -> Void
  ) {
    let typeID = T.typeID
    guard var component = componentStorage[typeID]?[entity] as? T else { return }
    modify(&component)
    componentStorage[typeID]![entity] = component
  }

  public func hasComponent<T: Component>(_ type: T.Type, for entity: EntityID) -> Bool {
    let typeID = T.typeID
    return entityComponents[entity]?.contains(typeID) ?? false
  }

  public func removeComponent<T: Component>(_ type: T.Type, from entity: EntityID) {
    let typeID = T.typeID
    componentStorage[typeID]?[entity] = nil
    entityComponents[entity]?.remove(typeID)
  }

  public func destroyEntity(_ entity: EntityID) {
    guard let components = entityComponents[entity] else { return }

    for typeID in components {
      componentStorage[typeID]?[entity] = nil
    }

    entityComponents[entity] = nil
  }

  public func entitiesWith<T: Component>(_ type: T.Type) -> [(EntityID, T)] {
    let typeID = T.typeID
    guard let storage = componentStorage[typeID] else { return [] }

    return storage.compactMap { (entity, component) in
      guard let comp = component as? T else { return nil }
      return (entity, comp)
    }
  }

  public func entitiesWith<T1: Component, T2: Component>(
    _ type1: T1.Type,
    _ type2: T2.Type
  ) -> [(EntityID, T1, T2)] {
    let typeID1 = T1.typeID
    let typeID2 = T2.typeID

    return entityComponents.compactMap { (entity, components) in
      guard components.contains(typeID1) && components.contains(typeID2),
        let comp1 = componentStorage[typeID1]?[entity] as? T1,
        let comp2 = componentStorage[typeID2]?[entity] as? T2
      else {
        return nil
      }
      return (entity, comp1, comp2)
    }
  }

  public func addSystem<T: System>(_ system: T) {
    systems.append(system)
    systems.sort { $0.priority > $1.priority }
  }

  public func getSystem<T: System>(_ type: T.Type) -> T? {
    return systems.first { $0 is T } as? T
  }

  public func removeSystem<T: System>(_ type: T.Type) {
    systems.removeAll { $0 is T }
  }

  public func update(deltaTime: TimeInterval) {
    for system in systems where system.enabled {
      system.update(self, deltaTime: deltaTime)
    }
  }
}

extension ECS.Component {
  public static var typeID: ECS.ComponentTypeID {
    ObjectIdentifier(Self.self)
  }
}

extension ECS.System {
  public var priority: Int { 0 }
}
