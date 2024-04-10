public protocol RxSettingEnum: RxSettingCompatible {}

public extension RxSettingEnum where Self: RawRepresentable {
  static func fromPersistedValue(value: Any) -> Self {
    return Self(rawValue: value as! RawValue)!
  }

  func toPersistedValue() -> Any {
    return rawValue
  }
}
