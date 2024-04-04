import Foundation

extension UUID: RxSettingCompatible {
  public static func fromPersistedValue(value: Any) -> UUID {
    UUID(uuidString: value as! String)!
  }

  public func toPersistedValue() -> Any {
    uuidString
  }
}
