
import CRDTKit
import CRDTTest
import XCTest

extension GrowOnlySet where Element == Int {

    fileprivate static var random: Self {
        var set = GrowOnlySet<Int>()
        loop(.random(in: 1...1000)) { set.insert(.random) }
        return set
    }
}

final class GrowOnlySetTests: XCTestCase {

    func testInit() {
        let value = Int.random
        let set = GrowOnlySet([value])
        XCTAssert(set.contains(value))
    }

    func testContains() {
        let empty = GrowOnlySet<Int>()
        XCTAssertFalse(empty.contains(.random))
        let value = Int.random
        let set = GrowOnlySet([value])
        XCTAssertTrue(set.contains(value))
    }

    func testDecodable() throws {
        let data = try JSONEncoder().encode(Set([0,1,2,3]))
        let set = try JSONDecoder().decode(GrowOnlySet<Int>.self, from: data)
        XCTAssertEqual(set, [0,1,2,3])
    }

    func testEncodable() throws {
        let data = try JSONEncoder().encode(GrowOnlySet([0,1,2,3]))
        let set = try JSONDecoder().decode(Set<Int>.self, from: data)
        XCTAssertEqual(set, [0,1,2,3])
    }

    func testEquatable() {
        XCTAssertEqual(GrowOnlySet<Int>(), GrowOnlySet<Int>())
        let value = Int.random
        XCTAssertEqual(GrowOnlySet([value]), GrowOnlySet<Int>([value]))
    }

    func testExpressibleByArrayLiteral() {
        let value1 = Int.random
        let value2 = Int.random
        let set: GrowOnlySet = [value1, value2]
        XCTAssert(set.contains(value1))
        XCTAssert(set.contains(value2))
    }

    func testInsert() {
        var set = GrowOnlySet<Int>()
        let value1 = Int.random
        set.insert(value1)
        XCTAssertEqual(set, [value1])
        let value2 = Int.random
        set.insert(value2)
        XCTAssertEqual(set, [value1, value2])
    }

    func testFormUnion() {
        let value1 = Int.random
        let value2 = Int.random
        var set1 = GrowOnlySet([value1])
        let set2 = GrowOnlySet([value2])
        set1.formUnion(set2)
        XCTAssertEqual(set1, [value1, value2])
        XCTAssertEqual(set2, [value2])
    }

    func testLaws() {
        AssertAssociative { GrowOnlySet.random } mutate: { $0.insert(.random) }
        AssertCommutative { GrowOnlySet.random } mutate: { $0.insert(.random) }
        AssertIdempotent { GrowOnlySet.random } mutate: { $0.insert(.random) }
    }
}
