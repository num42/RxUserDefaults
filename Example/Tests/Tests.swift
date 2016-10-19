import XCTest
import RxUserDefaults
import RxSwift


class Tests: XCTestCase {


    var userDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()

        userDefaults = UserDefaults(suiteName: "testing")

    }
    
    override func tearDown() {

        // make sure we leave no values behind
        for key in userDefaults.dictionaryRepresentation().keys {
            userDefaults.removeObject(forKey: key)
        }

        super.tearDown()
    }
    
    func testStringSetting() {

        let setting = Setting<String>(userDefaults: userDefaults, key: "string_test", defaultValue: "nothing")

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

        let setting = Setting<Int>(userDefaults: userDefaults, key: "int_test", defaultValue: 42)

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

        let setting = Setting<Bool>(userDefaults: userDefaults, key: "bool_test", defaultValue: true)

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

        let setting = Setting<TestEnum>(userDefaults: userDefaults, key: "enum_test", defaultValue: .test0)

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

        let setting = Setting<[Int]>(userDefaults: userDefaults, key: "array_test", defaultValue: [1,2])

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



        let expectation = self.expectation(description: "values observed")

        let setting = Setting<String>(userDefaults: userDefaults, key: "rx_test", defaultValue: "nothing")


        _ = setting.asObservable().debug().take(4).toArray().subscribe(onNext: { (values) in

            // check the sequence
            XCTAssertEqual(values, ["nothing", "string_value_1", "string_value_2","nothing"])

            // release the semaphore
            expectation.fulfill()

            }, onError: { _ in
                XCTFail()
            }, onCompleted: nil, onDisposed: nil)

        setting.value = "string_value_1"
        setting.value = "string_value_2"
        setting.remove()


        waitForExpectations(timeout: 10)

    }
    
}

