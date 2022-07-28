
import CRDTKit
import XCTest

protocol Randomizable {
    static var random: Self { get }
}

extension Int: Randomizable {
    // Limited to stop overflows on addition
    static var random: Int { .random(in: -10_000..<10_000) }
}

extension CRDT where Self: Equatable & Randomizable {

    static func testCommutativity() {
        testCommutativity(equating: \.self)
    }

    static func testIdempotency() {
        testIdempotency(equating: \.self)
    }

    static func testAssociativity() {
        testAssociativity(equating: \.self)
    }
}

extension CRDT where Self: Randomizable {

    static func testCommutativity<Value: Equatable>(
        equating value: KeyPath<Self, Value>
    ) {
        for _ in 0..<1000 {
            let a = Self.random
            let b = Self.random
            XCTAssertEqual(
                a.merging(b)[keyPath: value],
                b.merging(a)[keyPath: value],
                "Not commutative."
            )
        }
    }

    static func testIdempotency<Value: Equatable>(
        equating value: KeyPath<Self, Value>
    ) {
        for _ in 0..<1000 {
            let a = Self.random
            XCTAssertEqual(
                a.merging(a)[keyPath: value],
                a[keyPath: value],
                "Not idempotent."
            )
        }
    }

    static func testAssociativity<Value: Equatable>(
        equating value: KeyPath<Self, Value>
    ) {
        for _ in 0..<1000 {
            let a = Self.random
            let b = Self.random
            let c = Self.random
            XCTAssertEqual(
                a.merging(b).merging(c)[keyPath: value],
                a.merging(b.merging(c))[keyPath: value],
                "Not associative."
            )
            XCTAssertEqual(
                a.merging(b).merging(c)[keyPath: value],
                (a.merging(b)).merging(c)[keyPath: value],
                "Not associative."
            )
        }
    }
}
