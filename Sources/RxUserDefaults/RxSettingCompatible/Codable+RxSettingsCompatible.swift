import Foundation

public extension RxSettingCompatible where Self: Codable {
  static func fromPersistedValue(value: Any) -> Self {
    try! JSONDecoder().decode(Self.self, from: value as! Data)
  }

  func toPersistedValue() -> Any {
    try! JSONEncoder().encode(self)
  }
}
