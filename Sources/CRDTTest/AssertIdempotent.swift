
import CRDTKit
import XCTest

// MARK: - CmRDT

public func AssertIdempotent<T: CmRDT & Equatable>(
    make: () -> T,
    operation: () -> T.Operation,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    AssertIdempotent(
        validating: \.self,
        make: make,
        operation: operation,
        file: file,
        line: line)
}

public func AssertIdempotent<T: CmRDT, V: Equatable>(
    validating keyPath: KeyPath<T, V>,
    make: () -> T,
    operation: () -> T.Operation,
    file: StaticString = #filePath,
    line: UInt = #line
) {

    let operation = operation()

    func assert(_ a: T) {
        XCTAssertEqual(
            a.applying(operation)[keyPath: keyPath],
            a.applying(operation).applying(operation)[keyPath: keyPath],
            "Not idempotent.",
            file: file,
            line: line
        )
    }

    loop(1000) {
        let a = make()
        assert(a)
    }
}

// MARK: - CvRDT

public func AssertIdempotent<T: CvRDT & Equatable>(
    make: () -> T,
    mutate: (inout T) -> (),
    file: StaticString = #filePath,
    line: UInt = #line
) {
    AssertIdempotent(
        validating: \.self,
        make: make,
        mutate: mutate,
        file: file,
        line: line)
}

public func AssertIdempotent<T: CvRDT, V: Equatable>(
    validating keyPath: KeyPath<T, V>,
    make: () -> T,
    mutate: (inout T) -> (),
    file: StaticString = #filePath,
    line: UInt = #line
) {

    func assert(_ a: T) {
        XCTAssertEqual(
            a.merging(a)[keyPath: keyPath],
            a[keyPath: keyPath],
            "Not idempotent.",
            file: file,
            line: line
        )
    }

    loop(1000) {
        var a = make()
        assert(a)

        mutate(&a)
        assert(a)
    }
}