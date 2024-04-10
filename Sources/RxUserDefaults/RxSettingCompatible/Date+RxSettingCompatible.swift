import Foundation

extension Date: RxSettingCompatible {
  public static func fromPersistedValue(value: Any) -> Date {
    DateFormatter.iso8601.date(from: value as! String)!
  }

  public func toPersistedValue() -> Any {
    DateFormatter.iso8601.string(from: self)
  }
}
