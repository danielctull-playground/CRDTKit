
import CRDTKit
import XCTest

final class AtomTests: XCTestCase {

    func testInit() {
        let atom = Atom(
            id: AtomID(site: "A", time: Time()),
            parent: AtomID(site: "B", time: .one),
            value: "Value")
        XCTAssertEqual(atom.id.site, "A")
        XCTAssertEqual(atom.id.time, Time())
        XCTAssertEqual(atom.parent?.site, "B")
        XCTAssertEqual(atom.parent?.time, .one)
        XCTAssertEqual(atom.value, "Value")
    }

    func testEquatable() {
        XCTAssertEqual(
            Atom(
               id: AtomID(site: "A", time: Time()),
               value: 2),
            Atom(
               id: AtomID(site: "A", time: Time()),
               parent: nil,
               value: 2))
    }
}

extension Time {
    fileprivate static let one = {
        var time = Time()
        time.increment()
        return time
    }()
}
