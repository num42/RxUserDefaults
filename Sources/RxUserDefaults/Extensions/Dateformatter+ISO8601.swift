import Foundation

extension DateFormatter {
  static var iso8601: DateFormatter {
    let formatter = DateFormatter()

    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

    return formatter
  }
}
