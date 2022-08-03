
import CRDTKit
import XCTest

// MARK: - CmRDT

public func AssertAssociative<T: CmRDT & Equatable>(
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

public func AssertAssociative<T: CmRDT, V: Equatable>(
    validating keyPath: KeyPath<T, V>,
    make: () -> T,
    operation makeOperation: () -> T.Operation,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    
    func assert(_ a: T, _ o1: T.Operation, _ o2: T.Operation) {
        XCTAssertEqual(
            a.applying(o1).applying(o2)[keyPath: keyPath],
            a.applying(o2).applying(o2)[keyPath: keyPath],
            "Not idempotent.",
            file: file,
            line: line
        )
    }

    loop(1000) {
        let a = make()
        let op1 = makeOperation()
        let op2 = makeOperation()
        assert(a, op1, op2)
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

        mutate(&a)
        mutate(&b)
        mutate(&c)
        assert(a, b, c)
    }
}
