
import CRDTKit
import CRDTTest
import XCTest

extension GCounter where Value == Int {
    static var random: GCounter<Int> { GCounter(.random) }
}

final class GCounterTests: XCTestCase {

    func testLaws() {
        AssertAssociative(validating: \.value) { GCounter.random } mutate: { $0 += .random(in: 0...1000) }
        AssertCommutative(validating: \.value) { GCounter.random } mutate: { $0 += .random(in: 0...1000) }
        AssertIdempotent(validating: \.value) { GCounter.random } mutate: { $0 += .random(in: 0...1000) }
    }

    func testBehavior() {
        var a = GCounter(10)
        var b = GCounter(0)
        b.merge(a)
        XCTAssertEqual(b.value, 10)
        a += 1
        b += 1
        a.merge(b)
        b.merge(a)
        XCTAssertEqual(a.value, 12)
        XCTAssertEqual(b.value, 12)
    }
}
