
import XCTest
import CRDTKit

final class TimeTests: XCTestCase {

    func testZero() {
        XCTAssertEqual(Time.zero, Time.zero)
    }

    func testIncremented() {
        XCTAssertGreaterThan(Time.zero.incremented, Time.zero)
    }

    func testIncrement() {
        let time1 = Time.zero
        var time2 = time1
        time2.increment()
        XCTAssertGreaterThan(time2, time1)
    }

    func testCustomStringConvertible() {
        XCTAssertEqual(Time.zero.description, "0")
        XCTAssertEqual(Time.one.description, "1")
        XCTAssertEqual(Time.two.description, "2")
        XCTAssertEqual(Time.three.description, "3")
    }
}

extension Time {
    static let one = Time.zero.incremented
    static let two = Time.one.incremented
    static let three = Time.two.incremented
}
