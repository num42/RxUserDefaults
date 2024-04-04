import Foundation

extension RxSettingCompatible where Self: Codable {
  public static func fromPersistedValue(value: Any) -> Self {
    try! JSONDecoder().decode(Self.self, from: value as! Data)
  }

  public func toPersistedValue() -> Any {
    try! JSONEncoder().encode(self)
  }
}
