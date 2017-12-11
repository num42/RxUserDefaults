import XCTest
import RxUserDefaults
import RxSwift
import RxTest
import RxBlocking

class Tests: XCTestCase {


    var userDefaults: UserDefaults!
    var settings: RxSettings!
    
    override func setUp() {
        super.setUp()

        userDefaults = UserDefaults(suiteName: "testing")
        settings = RxSettings(userDefaults: userDefaults)

    }
    
    override func tearDown() {

        // make sure we leave no values behind
        for key in userDefaults.dictionaryRepresentation().keys {
            userDefaults.removeObject(forKey: key)
        }

        super.tearDown()
    }
    
    func testStringSetting() {

        let setting = settings.setting(key: "string_test", defaultValue: "nothing")

        // first test default value
        XCTAssertEqual(setting.value, "nothing")
        // test that setting is not persisted
        XCTAssert(!setting.isSet)

        // set the value
        setting.value = "string_value"


        // check if value is present
        XCTAssertEqual(setting.value, "string_value")
        XCTAssert(setting.isSet)


        // remove value
        setting.remove()

        // check that value was removed
        XCTAssert(!setting.isSet)

    }

    func testIntSetting() {

        let setting = settings.setting(key: "int_test", defaultValue: 42)

        // first test default value
        XCTAssertEqual(setting.value, 42)
        // test that setting is not persisted
        XCTAssert(!setting.isSet)

        // set the value
        setting.value = 41


        // check if value is present
        XCTAssertEqual(setting.value, 41)
        XCTAssert(setting.isSet)


        // remove value
        setting.remove()

        // check that value was removed
        XCTAssert(!setting.isSet)
        
    }


    func testBoolSetting() {

        let setting = settings.setting(key: "bool_test", defaultValue: true)

        // first test default value
        XCTAssertEqual(setting.value, true)
        // test that setting is not persisted
        XCTAssert(!setting.isSet)

        // set the value
        setting.value = false


        // check if value is present
        XCTAssertEqual(setting.value, false)
        XCTAssert(setting.isSet)


        // remove value
        setting.remove()

        // check that value was removed
        XCTAssert(!setting.isSet)
        
    }


    func testEnumSetting() {

        enum TestEnum: Int, RxSettingEnum {

            case test0 = 0,
            test1 = 1,
            test2 = 2
            
        }

        let setting:Setting<TestEnum> = settings.setting(key: "enum_test", defaultValue: .test0)

        // first test default value
        XCTAssertEqual(setting.value, .test0)
        // test that setting is not persisted
        XCTAssert(!setting.isSet)

        // set the value
        setting.value = .test2


        // check if value is present
        XCTAssertEqual(setting.value, .test2)
        XCTAssert(setting.isSet)


        // remove value
        setting.remove()

        // check that value was removed
        XCTAssert(!setting.isSet)
        
    }

    func testArraySetting() {

        let setting:Setting<[Int]> = settings.setting(key: "array_test", defaultValue: [1,2])

        // first test default value
        XCTAssertEqual(setting.value, [1,2])
        // test that setting is not persisted
        XCTAssert(!setting.isSet)

        // set the value
        setting.value = [1,2,3]


        // check if value is present
        XCTAssertEqual(setting.value, [1,2,3])
        XCTAssert(setting.isSet)


        // remove value
        setting.remove()

        // check that value was removed
        XCTAssert(!setting.isSet)
        
    }


    func testSetSetting() {

        let setting:Setting<Set<Int>> = settings.setting(key: "set_test", defaultValue: [1,2])

        // first test default value
        XCTAssertEqual(setting.value, [1,2])
        // test that setting is not persisted
        XCTAssert(!setting.isSet)

        // set the value
        setting.value = [1,2,3]


        // check if value is present
        XCTAssertEqual(setting.value, [1,2,3])
        XCTAssert(setting.isSet)


        // remove value
        setting.remove()

        // check that value was removed
        XCTAssert(!setting.isSet)
        
    }


    func testRxSetting() {

        let scheduler = TestScheduler(initialClock: 0)
        let setting = settings.setting(key: "rx_test", defaultValue: "nothing")

        let result = scheduler.start { () -> Observable<String> in
            
            _ = scheduler.createHotObservable([next(500, ())]).subscribe(onNext: { _ in
                
                // set two values
                setting.value = "string_value_1"
                setting.value = "string_value_2"
                
                // set a value directly
                self.userDefaults.set("string_value_3", forKey: "rx_test")
                
                // remove a value
                setting.remove()
                
            })
            
            return setting.asObservable()
        }
        
        let rawResult = try! Observable.from(result.events).map { event -> String in
            event.value.element!
            }.toBlocking().toArray()

        // TODO: seems like some ios versions have problems with KVO, see: https://github.com/ReactiveX/RxSwift/issues/1143
        // KVO sends duplicate messages on some ios versions so we have to build a special check
        if rawResult.count == 8 {
            XCTAssertEqual( rawResult, ["nothing",
                                        "string_value_1", "string_value_1", "string_value_2","string_value_2", "string_value_3", "string_value_3",
                                        "nothing"])
        } else if rawResult.count == 5 {
            XCTAssertEqual( rawResult, ["nothing",
                                        "string_value_1", "string_value_2","string_value_3",
                                        "nothing"])
        } else {
            XCTFail()
        }
        

    }
    
    func testRxEnumSetting() {
        
        enum TestEnum: String, RxSettingEnum {
            
            case test0,
            test1,
            test2,
            defaultValue
            
        }
        
        
        let scheduler = TestScheduler(initialClock: 0)
        let setting = settings.setting(key: "rx_enum_test", defaultValue: TestEnum.defaultValue)
        
        let result = scheduler.start { () -> Observable<TestEnum> in
            
            _ = scheduler.createHotObservable([next(500, ())]).subscribe(onNext: { _ in
                
                // set two values
                setting.value = .test0
                setting.value = .test1
                
                // set a value directly
                self.userDefaults.set(TestEnum.test2.rawValue, forKey: "rx_enum_test")
                
                // remove a value
                setting.remove()
            })
            
            return setting.asObservable()
        }
        
        
        let rawResult = try! Observable.from(result.events).map { event -> TestEnum in
            event.value.element!
            }.toBlocking().toArray()
        
        
        // TODO: seems like some ios versions have problems with KVO, see: https://github.com/ReactiveX/RxSwift/issues/1143
        // KVO sends duplicate messages on some ios versions so we have to build a special check
        if rawResult.count == 8 {
            XCTAssertEqual( rawResult, [.defaultValue,
                                        .test0, .test0, .test1, .test1, .test2, .test2,
                                        .defaultValue])
        } else if rawResult.count == 5 {
            XCTAssertEqual( rawResult, [.defaultValue,
                                        .test0, .test1, .test2,
                                        .defaultValue])
        } else {
            XCTFail()
        }
    
        
    }

}

