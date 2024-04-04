import Foundation

public class RxSettings {
  public init(userDefaults: UserDefaults) {
    userDefaultsStorageLayer = UserDefaultsStorageLayer(userDefaults: userDefaults)
  }

  public func setting<T: RxSettingCompatible>(key: String, defaultValue: T) -> Setting<T> {
      Setting<T>(
        storageLayer: userDefaultsStorageLayer,
        key: key,
        defaultValue: defaultValue
      )
  }

  private let userDefaultsStorageLayer: UserDefaultsStorageLayer
}
