
import XCTest
import CRDTKit

final class TimeTests: XCTestCase {

    func testInit() {
        XCTAssertEqual(Time(), Time())
    }

    func testIncrement() {
        let time1 = Time()
        var time2 = time1
        time2.increment()
        XCTAssertGreaterThan(time2, time1)
    }
}
