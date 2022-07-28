
import CRDTKit
import XCTest

final class AtomTests: XCTestCase {

    func testInit() {
        let atom = Atom(
            id: AtomID(site: "A", time: .zero),
            parent: AtomID(site: "B", time: .one),
            value: "Value")
        XCTAssertEqual(atom.id.site, "A")
        XCTAssertEqual(atom.id.time, .zero)
        XCTAssertEqual(atom.parent?.site, "B")
        XCTAssertEqual(atom.parent?.time, .one)
        XCTAssertEqual(atom.value, "Value")
    }

    func testEquatable() {
        XCTAssertEqual(
            Atom(
               id: AtomID(site: "A", time: .zero),
               value: 2),
            Atom(
               id: AtomID(site: "A", time: .zero),
               parent: nil,
               value: 2))
    }
}

extension Time {

    fileprivate static let one = {
        var time = zero
        time.increment()
        return time
    }()
}
