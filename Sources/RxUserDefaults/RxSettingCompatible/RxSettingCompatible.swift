public protocol RxSettingCompatible {
  static func fromPersistedValue(value: Any) -> Self

  func toPersistedValue() -> Any
}
