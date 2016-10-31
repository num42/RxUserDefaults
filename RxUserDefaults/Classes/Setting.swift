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

import RxSwift
import RxCocoa

public class Setting<T: RxSettingCompatible> {
    let userDefaults: UserDefaults
    public let key: String
    public let defaultValue: T


    public init(userDefaults: UserDefaults, key: String, defaultValue: T) {
        self.key = key
        self.userDefaults =  userDefaults
        self.defaultValue = defaultValue

    }

    public func asObservable() -> Observable<T> {
        return userDefaults.rx.observe(T.self, key).map({ value -> T in
            if value == nil {
                return self.defaultValue
            }
            return value!
        })
    }

    public var isSet: Bool {
        get {
            return userDefaults.dictionaryRepresentation().keys.contains(self.key)
        }
    }

    public func remove() {
        userDefaults.removeObject(forKey: self.key)
    }

    public var value: T {
        set(newValue) {
            let persValue = newValue.toPersistedValue()
            userDefaults.set(persValue, forKey: key)
        }
        get {

            if self.isSet {
                return T.fromPersistedValue(value: userDefaults.value(forKey: self.key))
            }

            return defaultValue

        }
    }
}

public protocol RxSettingCompatible {

    func toPersistedValue() -> Any

    static func fromPersistedValue(value:Any) -> Self

}


public protocol RxSettingEnum : RxSettingCompatible {

}

extension Int: RxSettingCompatible {

    public func toPersistedValue() -> Any {
        return self
    }

    public static func fromPersistedValue(value:Any) -> Int {
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

    public func toPersistedValue() -> Any {
        return self.rawValue
    }

    public static func fromPersistedValue(value: Any) -> Self {
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

