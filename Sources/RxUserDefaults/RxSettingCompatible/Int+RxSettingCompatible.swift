extension Int: RxSettingCompatible {
  public static func fromPersistedValue(value: Any) -> Int {
    return value as! Int
  }

  public func toPersistedValue() -> Any {
    return self
  }
}
