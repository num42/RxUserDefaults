import RxSwift

public protocol StorageLayer {
    func asObservable<T: RxSettingCompatible>(
        key: String,
        defaultValue: T
    ) -> Observable<T>
    
    func get<T: RxSettingCompatible>(
        key: String,
        defaultValue: T
    ) -> T

    func isSet(key: String) -> Bool
    
    func remove(key: String)
    
    func save<T: RxSettingCompatible>(
        value: T,
        key: String
    )
}
