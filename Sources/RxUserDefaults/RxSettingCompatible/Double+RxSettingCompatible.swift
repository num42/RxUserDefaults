extension Double: RxSettingCompatible {
  public static func fromPersistedValue(value: Any) -> Double {
    value as! Double
  }

  public func toPersistedValue() -> Any {
    self
  }
}
