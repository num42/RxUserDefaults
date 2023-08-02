/*
 * Copyright (C) 2016 Number42
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation
import RxCocoa
import RxSwift

public protocol StorageLayer {
  func asObservable<T: RxSettingCompatible>(key: String, defaultValue: T) -> Observable<T>

  func isSet(key: String) -> Bool

  func remove(key: String)

  func save<T: RxSettingCompatible>(value: T, key: String)

  func get<T: RxSettingCompatible>(key: String, defaultValue: T) -> T
}

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

public class RxSettings {
  public init(userDefaults: UserDefaults) {
    userDefaultsStorageLayer = UserDefaultsStorageLayer(userDefaults: userDefaults)
  }

  public func setting<T: RxSettingCompatible>(key: String, defaultValue: T) -> Setting<T> {
    return Setting<T>(storageLayer: userDefaultsStorageLayer, key: key, defaultValue: defaultValue)
  }

  private let userDefaultsStorageLayer: UserDefaultsStorageLayer
}

public class Setting<T: RxSettingCompatible> {
  public init(storageLayer: StorageLayer, key: String, defaultValue: T) {
    self.storageLayer = storageLayer
    self.key = key
    self.defaultValue = defaultValue
  }

  public let key: String
  public let defaultValue: T

  public var isSet: Bool {
    return storageLayer.isSet(key: key)
  }

  public var value: T {
    set(newValue) {
      storageLayer.save(value: newValue, key: key)
    }
    get {
      return storageLayer.get(key: key, defaultValue: defaultValue)
    }
  }

  public func asObservable() -> Observable<T> {
    return storageLayer.asObservable(key: key, defaultValue: defaultValue)
  }

  public func remove() {
    storageLayer.remove(key: key)
  }

  let storageLayer: StorageLayer
}

public protocol RxSettingCompatible {
  func toPersistedValue() -> Any

  static func fromPersistedValue(value: Any) -> Self
}

public protocol RxSettingEnum: RxSettingCompatible {}

extension Int: RxSettingCompatible {
  public func toPersistedValue() -> Any {
    return self
  }

  public static func fromPersistedValue(value: Any) -> Int {
    return value as! Int
  }
}

extension Bool: RxSettingCompatible {
  public func toPersistedValue() -> Any {
    return self
  }

  public static func fromPersistedValue(value: Any) -> Bool {
    return value as! Bool
  }
}

extension String: RxSettingCompatible {
  public func toPersistedValue() -> Any {
    return self
  }

  public static func fromPersistedValue(value: Any) -> String {
    return value as! String
  }
}

public extension RxSettingEnum where Self: RawRepresentable {
  func toPersistedValue() -> Any {
    return rawValue
  }

  static func fromPersistedValue(value: Any) -> Self {
    return Self(rawValue: value as! RawValue)!
  }
}

extension Array: RxSettingCompatible {

    public func toPersistedValue() -> Any {
        return self
    }

    public static func fromPersistedValue(value: Any) -> Array<Element> {
        return value as! Array<Element>
    }
}

// Set is not supported, work around with an array
extension Set: RxSettingCompatible {
  public func toPersistedValue() -> Any {
    return Array(self)
  }

  public static func fromPersistedValue(value: Any) -> Set<Element> {
    return Set(value as! [Element])
  }
}
