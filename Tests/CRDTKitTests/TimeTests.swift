
import XCTest
import CRDTKit

final class TimeTests: XCTestCase {

    func testZero() {
        XCTAssertEqual(Time.zero, Time.zero)
    }

    func testIncrement() {
        let time1 = Time.zero
        var time2 = time1
        time2.increment()
        XCTAssertGreaterThan(time2, time1)
    }
}
