
import CRDTKit
import CRDTTest
import XCTest

final class LWWRegisterTests: XCTestCase {

    func testInit() {
        let value = Int.random
        let lww = LWWRegister(value)
        XCTAssertEqual(lww.value, value)
    }

    func testLWW() {
        let value = Int.random
        let value1 = Int.random
        let value2 = Int.random
        let value3 = Int.random

        var lww1 = LWWRegister(value, site: "A")
        var lww2 = LWWRegister(value, site: "B")
        XCTAssertEqual(lww1.merging(lww2).value, value)
        XCTAssertEqual(lww2.merging(lww1).value, value)

        lww1.setValue(value1, site: "A")
        XCTAssertEqual(lww1.merging(lww2).value, value1)
        XCTAssertEqual(lww2.merging(lww1).value, value1)

        print("1:", lww1.debugDescription)
        print("2:", lww2.debugDescription)

        lww2.setValue(value2, site: "B")
        XCTAssertEqual(lww1.merging(lww2).value, value2)
        XCTAssertEqual(lww2.merging(lww1).value, value2)

        print("1:", lww1.debugDescription)
        print("2:", lww2.debugDescription)

        lww1.setValue(value3, site: "A")
        XCTAssertEqual(lww1.merging(lww2).value, value3)
        print("1:", lww1.debugDescription)
        print("2:", lww2.debugDescription)
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

    func testCmRDT() {
        AssertAssociative(validating: \.value) { LWWRegister(Int.random) } transaction: { $0.transaction(value: .random) }
        AssertCommutative(validating: \.value) { LWWRegister(Int.random) } transaction: { $0.transaction(value: .random) }
        AssertIdempotent(validating: \.value) { LWWRegister(Int.random) } transaction: { $0.transaction(value: .random) }
    }

    func testCvRDT() {
        AssertAssociative(validating: \.value) { LWWRegister(Int.random) } mutate: { $0.setValue(.random, site: Site()) }
        AssertCommutative(validating: \.value) { LWWRegister(Int.random) } mutate: { $0.setValue(.random, site: Site()) }
        AssertIdempotent(validating: \.value) { LWWRegister(Int.random) } mutate: { $0.setValue(.random, site: Site()) }
    }
}
