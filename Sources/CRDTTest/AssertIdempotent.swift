
import CRDTKit
import XCTest

// MARK: - CmRDT

public func AssertIdempotent<T: CmRDT & Equatable>(
    make: () -> T,
    transaction: (T) -> T.Transaction,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    AssertIdempotent(
        validating: \.self,
        make: make,
        transaction: transaction,
        file: file,
        line: line)
}

public func AssertIdempotent<T: CmRDT, V: Equatable>(
    validating keyPath: KeyPath<T, V>,
    make: () -> T,
    transaction: (T) -> T.Transaction,
    file: StaticString = #filePath,
    line: UInt = #line
) {

    func assert(_ a: T) {
        XCTAssertEqual(
            a.applying(a.transactions)[keyPath: keyPath],
            a[keyPath: keyPath],
            "Not idempotent.",
            file: file,
            line: line
        )
    }

    loop(1000) {
        var a = make()
        assert(a)

        loop(.random(in: 1...10)) { a.apply(transaction(a)) }
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

        loop(.random(in: 1...10)) { mutate(&a) }
        assert(a)
    }
}
