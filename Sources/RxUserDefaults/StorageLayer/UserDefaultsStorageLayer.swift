import Foundation
import RxSwift

public class UserDefaultsStorageLayer: StorageLayer {
  public init(userDefaults: UserDefaults) {
    self.userDefaults = userDefaults
  }

  public func asObservable<T: RxSettingCompatible>(key: String, defaultValue: T) -> Observable<T> {
    return userDefaults.rx.observe(T.self, key).map { _ -> T in
      self.get(key: key, defaultValue: defaultValue)
    }
  }

  public func isSet(key: String) -> Bool {
    return userDefaults.dictionaryRepresentation().keys.contains(key)
  }

  public func remove(key: String) {
    userDefaults.removeObject(forKey: key)
  }

  public func save<T: RxSettingCompatible>(value: T, key: String) {
    let persValue = value.toPersistedValue()
    userDefaults.set(persValue, forKey: key)
  }

  public func get<T: RxSettingCompatible>(key: String, defaultValue: T) -> T {
    if isSet(key: key) {
      return T.fromPersistedValue(value: userDefaults.value(forKey: key) as Any)
    }

    return defaultValue
  }

  let userDefaults: UserDefaults
}
