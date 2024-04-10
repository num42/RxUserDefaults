import RxSwift

// A protocol that is used by the https://github.com/num42/swift-macro-autosettingtype macro
public protocol SettingTypeProtocol {
  associatedtype SettingType: RxSettingCompatible

  var setting: Setting<SettingType> { get set }

  func asObservable() -> Observable<SettingType>
  var isSet: Bool { get }
  func remove()
  var value: SettingType { get }
  func setValue(value: SettingType)
}

public extension SettingTypeProtocol {
  func asObservable() -> Observable<SettingType> {
    setting.asObservable()
  }

  var isSet: Bool {
    setting.isSet
  }

  func remove() {
    setting.remove()
  }

  var value: SettingType {
    setting.value
  }

  func setValue(value: SettingType) {
    setting.value = value
  }
}
