import Foundation
import RxSwift

public class UserDefaultsStorageLayer: StorageLayer {
  public init(userDefaults: UserDefaults) {
    self.userDefaults = userDefaults
  }

  public func asObservable<T: RxSettingCompatible>(key: String, defaultValue: T) -> Observable<T> {
    return Observable.create { observer in
      let keyValueObserver = KeyValueObserver(object: self.userDefaults, keyPath: key) {
        observer.onNext(self.get(key: key, defaultValue: defaultValue))
      }

      return Disposables.create { keyValueObserver.invalidate() }
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

/// KVO on one key: `.initial` fires once on
/// subscribe, then once per change notification. Retains the observed object.
private final class KeyValueObserver: NSObject {
  init(object: NSObject, keyPath: String, onChange: @escaping () -> Void) {
    self.object = object
    self.keyPath = keyPath
    self.onChange = onChange
    super.init()
    object.addObserver(self, forKeyPath: keyPath, options: [.initial, .new], context: nil)
  }

  func invalidate() {
    object.removeObserver(self, forKeyPath: keyPath)
  }

  override func observeValue(
    forKeyPath keyPath: String?,
    of object: Any?,
    change: [NSKeyValueChangeKey: Any]?,
    context: UnsafeMutableRawPointer?
  ) {
    // Serializes onNext across threads; recursive, as onNext may set the key.
    lock.lock()
    defer { lock.unlock() }
    onChange()
  }

  private let object: NSObject
  private let keyPath: String
  private let onChange: () -> Void
  private let lock = NSRecursiveLock()
}
