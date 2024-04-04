// Set is not supported, work around with an array
extension Set: RxSettingCompatible {
  public static func fromPersistedValue(value: Any) -> Set<Element> {
    Set(value as! [Element])
  }

  public func toPersistedValue() -> Any {
    Array(self)
  }
}
