
import CRDTKit
import CRDTTest
import XCTest

extension GCounter where Value == Int {
    static var random: GCounter<Int> { GCounter(.random) }
}

final class GCounterTests: XCTestCase {

    func testCvRDTBehaviour() {
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

    func testCvRDT() {
        AssertAssociative(validating: \.value) { GCounter.random } mutate: { $0 += .random(in: 0...1000) }
        AssertCommutative(validating: \.value) { GCounter.random } mutate: { $0 += .random(in: 0...1000) }
        AssertIdempotent(validating: \.value) { GCounter.random } mutate: { $0 += .random(in: 0...1000) }
    }

    func testCmRDTBehaviour() {
        var a = GCounter(10)
        var b = GCounter(0)
        b.apply(a.transactions)
        XCTAssertEqual(b.value, 10)
        a += 1
        b += 1000
        b += 1000
        b += 1000
        a.apply(b.transactions)
        b.apply(a.transactions)

        let op = b.transaction(increment: 0)
        b.apply(op)
        a.apply(op)

        XCTAssertEqual(a.value, 3011)
        XCTAssertEqual(b.value, 3011)

    }

    func testCmRDT() {
        AssertAssociative(validating: \.value) { GCounter.random } transaction: { $0.transaction(increment: .random(in: 0...1000)) }
        AssertCommutative(validating: \.value) { GCounter.random } transaction: { $0.transaction(increment: .random(in: 0...1000)) }
        AssertIdempotent(validating: \.value) { GCounter.random } transaction: { $0.transaction(increment: .random(in: 0...1000)) }
    }
}
