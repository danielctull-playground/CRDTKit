
import CRDTKit
import XCTest

// MARK: - Assert Associative

func AssertAssociative<T: CRDT & Equatable>(
    _ make: () -> T,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    AssertAssociative(validating: \.self, make, file: file, line: line)
}

func AssertAssociative<T: CRDT, V: Equatable>(
    validating keyPath: KeyPath<T, V>,
    _ make: () -> T,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    loop(1000) {
        let a = make()
        let b = make()
        let c = make()
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
}

// MARK: - Assert Commutative

func AssertCommutative<T: CRDT & Equatable>(
    _ make: () -> T,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    AssertCommutative(validating: \.self, make, file: file, line: line)
}

func AssertCommutative<T: CRDT, V: Equatable>(
    validating keyPath: KeyPath<T, V>,
    _ make: () -> T,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    loop(1000) {
        let a = make()
        let b = make()
        XCTAssertEqual(
            a.merging(b)[keyPath: keyPath],
            b.merging(a)[keyPath: keyPath],
            "Not commutative.",
            file: file,
            line: line
        )
    }
}

// MARK: - Assert Idempotent

func AssertIdempotent<T: CRDT & Equatable>(
    _ make: () -> T,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    AssertIdempotent(validating: \.self, make, file: file, line: line)
}

func AssertIdempotent<T: CRDT, V: Equatable>(
    validating keyPath: KeyPath<T, V>,
    _ make: () -> T,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    loop(1000) {
        let a = make()
        XCTAssertEqual(
            a.merging(a)[keyPath: keyPath],
            a[keyPath: keyPath],
            "Not idempotent.",
            file: file,
            line: line
        )
    }
}
