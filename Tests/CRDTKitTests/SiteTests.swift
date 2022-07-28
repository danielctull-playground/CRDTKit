
import XCTest
import CRDTKit

final class SiteTests: XCTestCase {

    func testInit() {
        XCTAssertNotEqual(Site(), Site())
    }

    func testComparable() {
        let site1: Site = "Site 1"
        let site2: Site = "Site 2"
        XCTAssertGreaterThan(site2, site1)
    }
}
