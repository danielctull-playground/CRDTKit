
import CRDTKit
import CRDTTest
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

    func testDecodable() throws {
        let value = Int.random
        let data = try JSONEncoder().encode(value)
        let max = try JSONDecoder().decode(Max<Int>.self, from: data)
        XCTAssertEqual(max.value, value)
    }

    func testEncodable() throws {
        let value = Int.random
        let data = try JSONEncoder().encode(Max(value))
        let int = try JSONDecoder().decode(Int.self, from: data)
        XCTAssertEqual(int, value)
    }

    func testCvRDT() {
        AssertCommutative { Max(Int.random) } mutate: { $0.value = .random }
        AssertAssociative { Max(Int.random) } mutate: { $0.value = .random }
        AssertIdempotent { Max(Int.random) } mutate: { $0.value = .random }
    }

    func testCmRDT() {
        AssertAssociative { Max(Int.random) } operation: { $0.setValue(.random) }
//        AssertCommutative { Max(Int.random) } mutate: { $0.value = .random }
//        AssertIdempotent { Max(Int.random) } transaction: { .update(.random) }
    }
}

public func AssertAssociative<T: CmRDT & Equatable>(
    make: () -> T,
    operation: (T) -> T.Operation,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    AssertAssociative(
        validating: \.self,
        make: make,
        operation: operation,
        file: file,
        line: line)
}

public func AssertAssociative<T: CmRDT, V: Equatable>(
    validating keyPath: KeyPath<T, V>,
    make: () -> T,
    operation: (T) -> T.Operation,
    file: StaticString = #filePath,
    line: UInt = #line
) {

    func assert(_ a: T, _ b: T, _ c: T) {
        XCTAssertEqual(
            a.applying(b.transactions).applying(c.transactions)[keyPath: keyPath],
            a.applying((b.applying(c.transactions)).transactions)[keyPath: keyPath],
            "Not idempotent.",
            file: file,
            line: line
        )
    }

    loop(1000) {
        var a = make()
        var b = make()
        var c = make()
        assert(a, b, c)

        a.apply(a.transaction(site: Site(), operation: operation(a)))
        b.apply(b.transaction(site: Site(), operation: operation(b)))
        c.apply(c.transaction(site: Site(), operation: operation(c)))
        assert(a, b, c)
    }
}
