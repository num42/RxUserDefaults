extension Array: RxSettingCompatible where Element: RxSettingCompatible {
  public static func fromPersistedValue(value: Any) -> [Element] {
      (value as! [Any])
      .map { Element.fromPersistedValue(value: $0) }
  }

  public func toPersistedValue() -> Any {
    map { $0.toPersistedValue() }
  }
}
