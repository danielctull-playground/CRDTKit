
import CRDTKit
import CRDTTest
import XCTest

extension GSet where Element == Int {

    fileprivate static var random: Self {
        var set = GSet<Int>()
        loop(.random(in: 1...1000)) { set.insert(.random) }
        return set
    }
}

final class GSetTests: XCTestCase {

    func testInit() {
        let value = Int.random
        let set = GSet([value])
        XCTAssert(set.contains(value))
    }

    func testContains() {
        let empty = GSet<Int>()
        XCTAssertFalse(empty.contains(.random))
        let value = Int.random
        let set = GSet([value])
        XCTAssertTrue(set.contains(value))
    }

    func testDecodable() throws {
        let data = try JSONEncoder().encode(Set([0,1,2,3]))
        let set = try JSONDecoder().decode(GSet<Int>.self, from: data)
        XCTAssertEqual(set, [0,1,2,3])
    }

    func testEncodable() throws {
        let data = try JSONEncoder().encode(GSet([0,1,2,3]))
        let set = try JSONDecoder().decode(Set<Int>.self, from: data)
        XCTAssertEqual(set, [0,1,2,3])
    }

    func testEquatable() {
        XCTAssertEqual(GSet<Int>(), GSet<Int>())
        let value = Int.random
        XCTAssertEqual(GSet([value]), GSet<Int>([value]))
    }

    func testExpressibleByArrayLiteral() {
        let value1 = Int.random
        let value2 = Int.random
        let set: GSet = [value1, value2]
        XCTAssert(set.contains(value1))
        XCTAssert(set.contains(value2))
    }

    func testInsert() {
        var set = GSet<Int>()
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
        var set1 = GSet([value1])
        let set2 = GSet([value2])
        set1.formUnion(set2)
        XCTAssertEqual(set1, [value1, value2])
        XCTAssertEqual(set2, [value2])
    }

    func testLaws() {
        AssertAssociative { GSet.random } mutate: { $0.insert(.random) }
        AssertCommutative { GSet.random } mutate: { $0.insert(.random) }
        AssertIdempotent { GSet.random } mutate: { $0.insert(.random) }
    }
}
