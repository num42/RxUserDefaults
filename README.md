# RxUserDefaults

[![CI Status](http://img.shields.io/travis/num42/RxUserDefaults.svg?style=flat)](https://travis-ci.org/num42/RxUserDefaults)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Overview
RxUserDefaults is a reactive solution for managing user defaults, inspired by [rx-preferences] with type handling influenced by [wrap] and [unbox].

## Usage

To create a setting, initialize the class using its constructor:
```swift
let settings = RxSettings(userDefaults: userDefaults)
let setting = settings.setting(key: "INSERT_KEY", defaultValue: "DEFAULT")
```
The arguments are self-explanatory.

Supported Types:

- Array (with types supported by UserDefaults)
- Bool
- Codable (using JSON Decoder)
- Date (as ISO8601 String)
- Double
- Enum (enum must conform to the RxSettingEnum protocol)
- Int
- Set
- String
- UUID

Functions available:
```swift
// Retrieve the value
let val = setting.value

// Set the value
setting.value = val

// Check if the value is saved (note: the default value is not automatically saved)
setting.isSet

// Delete the value
setting.remove()

// Provides a hot observable that triggers on every change and starts with the current value (or default value)
setting.asObservable()
```

## Storage Layer
If you prefer not to use UserDefaults as a storage layer, you can implement your own by confirming to the StorageLayer Protocol.

## Warnings & TODOs
The goal is to support all types that UserDefaults supports (e.g., Dictionary, URL). For now, you can expand the library to more types by conforming to the RxSettingCompatible protocol. However, note that persisting types not supported by UserDefaults will fail silently.

## Installation
RxUserDefaults is available through SPM.

## Requirements
- [RxSwift](https://github.com/ReactiveX/RxSwift)

## Authors
- David Kraus, kraus.david.dev@gmail.com
- Hans-Martin Schuller, hm.schuller@gmail.com
- Wolfgang Lutz, wolfgang@lutz-wiesent.de

## License
Licensed under the Apache License, Version 2.0. See the [License](https://opensource.org/licenses/Apache-2.0) for details.

[rx-preferences]: https://github.com/f2prateek/rx-preferences
[wrap]: https://github.com/JohnSundell/Wrap
[unbox]: https://github.com/JohnSundell/Unbox