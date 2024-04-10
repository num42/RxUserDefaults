extension String: RxSettingCompatible {
  public static func fromPersistedValue(value: Any) -> String {
    return value as! String
  }

  public func toPersistedValue() -> Any {
    return self
  }
}
