extension Bool: RxSettingCompatible {
  public static func fromPersistedValue(value: Any) -> Bool {
    return value as! Bool
  }

  public func toPersistedValue() -> Any {
    return self
  }
}
