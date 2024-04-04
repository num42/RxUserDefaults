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
      storageLayer.get(key: key, defaultValue: defaultValue)
    }
  }

  public func asObservable() -> Observable<T> {
    storageLayer.asObservable(
      key: key,
      defaultValue: defaultValue
    )
  }

  public func remove() {
    storageLayer.remove(key: key)
  }

  let storageLayer: StorageLayer
}
