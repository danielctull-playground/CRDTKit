
import CRDTKit
import XCTest

extension Max: Randomizable where Value: Randomizable {
    static var random: Max { Max(.random) }
}

final class MaxTests: XCTestCase {

    func test() {
        var a = Max(10)
        var b = Max(0)
        b.merge(a)
        XCTAssertEqual(b.value, 10)
        a.value += 1
        b.value += 1
        a.merge(b)
        b.merge(a)
        XCTAssertEqual(a.value, 11)
        XCTAssertEqual(b.value, 11)
    }

    func testLaws() {
        Max<Int>.testCommutativity()
        Max<Int>.testAssociativity()
        Max<Int>.testIdempotency()
    }
}
