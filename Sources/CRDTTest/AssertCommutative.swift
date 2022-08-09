
import CRDTKit
import XCTest

public func AssertCommutative<T: CvRDT & Equatable>(
    make: () -> T,
    mutate: (inout T) -> (),
    file: StaticString = #filePath,
    line: UInt = #line
) {
    AssertCommutative(
        validating: \.self,
        make: make,
        mutate: mutate,
        file: file,
        line: line)
}

public func AssertCommutative<T: CvRDT, V: Equatable>(
    validating keyPath: KeyPath<T, V>,
    make: () -> T,
    mutate: (inout T) -> (),
    file: StaticString = #filePath,
    line: UInt = #line
) {

    func assert(_ a: T, _ b: T) {
        XCTAssertEqual(
            a.merging(b)[keyPath: keyPath],
            b.merging(a)[keyPath: keyPath],
            "Not commutative.",
            file: file,
            line: line
        )
    }

    loop(1000) {
        var a = make()
        var b = make()
        assert(a, b)

        loop(.random(in: 1...10)) { mutate(&a) }
        loop(.random(in: 1...10)) { mutate(&b) }
        assert(a, b)
    }
}
