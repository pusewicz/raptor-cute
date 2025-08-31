import CuteFramework

extension Enemy {
  enum EnemyType: CustomStringConvertible, CaseIterable {
    case alan
    case bonBon
    case lips

    var description: String {
      switch self {
      case .alan: return "alan"
      case .bonBon: return "bon_bon"
      case .lips: return "lips"
      }
    }

    var boundsFactor: CF_V2 {
      switch self {
      case .alan: return CF_V2(0, -1)
      case .bonBon: return CF_V2(-1, -4)
      case .lips: return CF_V2(-2, -3)
      }
    }

    /// Fetch random enemy type
    static func random() -> EnemyType {
      let allTypes = Self.allCases
      let randomIndex = Int(arc4random_uniform(UInt32(allTypes.count)))
      return allTypes[randomIndex]
    }
  }
}
