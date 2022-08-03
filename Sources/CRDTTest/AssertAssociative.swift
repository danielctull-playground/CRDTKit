
import CRDTKit
import XCTest

public func AssertAssociative<T: CvRDT & Equatable>(
    make: () -> T,
    mutate: (inout T) -> (),
    file: StaticString = #filePath,
    line: UInt = #line
) {
    AssertAssociative(
        validating: \.self,
        make: make,
        mutate: mutate,
        file: file,
        line: line)
}

public func AssertAssociative<T: CvRDT, V: Equatable>(
    validating keyPath: KeyPath<T, V>,
    make: () -> T,
    mutate: (inout T) -> (),
    file: StaticString = #filePath,
    line: UInt = #line
) {

    func assert(_ a: T, _ b: T, _ c: T) {
        XCTAssertEqual(
            a.merging(b).merging(c)[keyPath: keyPath],
            a.merging(b.merging(c))[keyPath: keyPath],
            "Not associative.",
            file: file,
            line: line
        )
        XCTAssertEqual(
            a.merging(b).merging(c)[keyPath: keyPath],
            (a.merging(b)).merging(c)[keyPath: keyPath],
            "Not associative.",
            file: file,
            line: line
        )
    }

    loop(1000) {
        var a = make()
        var b = make()
        var c = make()
        assert(a, b, c)

        mutate(&a)
        mutate(&b)
        mutate(&c)
        assert(a, b, c)
    }
}
