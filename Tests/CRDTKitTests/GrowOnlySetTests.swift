
import CRDTKit
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
        XCTAssertEqual(set.elements, [value])
    }

    func testInsert() {
        var set = GrowOnlySet<Int>()
        let value1 = Int.random
        set.insert(value1)
        XCTAssertEqual(set.elements, [value1])
        let value2 = Int.random
        set.insert(value2)
        XCTAssertEqual(set.elements, [value1, value2])
    }

    func testFormUnion() {
        let value1 = Int.random
        let value2 = Int.random
        var set1 = GrowOnlySet([value1])
        let set2 = GrowOnlySet([value2])
        set1.formUnion(set2)
        XCTAssertEqual(set1.elements, [value1, value2])
    }

    func testLaws() {
        AssertCommutative { GrowOnlySet.random }
        AssertAssociative { GrowOnlySet.random }
        AssertIdempotent { GrowOnlySet.random }
    }
}
