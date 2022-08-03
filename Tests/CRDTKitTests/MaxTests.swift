
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
//        AssertAssociative { Max(Int.random) } operation: { .update(.random) }
//        AssertCommutative { Max(Int.random) } mutate: { $0.value = .random }
//        AssertIdempotent { Max(Int.random) } operation: { .update(.random) }
    }
}
