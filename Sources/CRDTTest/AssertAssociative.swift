
import CRDTKit
import XCTest

// MARK: - CmRDT

public func AssertAssociative<T: CmRDT & Equatable>(
    make: () -> T,
    operation: (T) -> T.Operation,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    AssertAssociative(
        validating: \.self,
        make: make,
        operation: operation,
        file: file,
        line: line)
}

public func AssertAssociative<T: CmRDT, V: Equatable>(
    validating keyPath: KeyPath<T, V>,
    make: () -> T,
    operation: (T) -> T.Operation,
    file: StaticString = #filePath,
    line: UInt = #line
) {

    func assert(_ a: T, _ b: T, _ c: T) {
        XCTAssertEqual(
            a.applying(b.operations).applying(c.operations)[keyPath: keyPath],
            a.applying((b.applying(c.operations)).operations)[keyPath: keyPath],
            "Not idempotent.",
            file: file,
            line: line
        )
    }

    loop(1000) {
        var a = make()
        var b = make()
        var c = make()
        assert(a, b, c)

        a.apply(operation(a))
        b.apply(operation(b))
        c.apply(operation(c))
        assert(a, b, c)
    }
}

// MARK: - CvRDT

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

        loop(.random(in: 1...10)) { mutate(&a) }
        loop(.random(in: 1...10)) { mutate(&b) }
        loop(.random(in: 1...10)) { mutate(&c) }
        assert(a, b, c)
    }
}
