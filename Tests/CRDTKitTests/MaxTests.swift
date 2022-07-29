
import CRDTKit
import XCTest

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
        AssertCommutative { Max(Int.random) }
        AssertAssociative { Max(Int.random) }
        AssertIdempotent { Max(Int.random) }
    }
}
