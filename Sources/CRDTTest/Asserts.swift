
import CRDTKit
import XCTest

public typealias Make<T> = () -> T
public typealias Mutate<T> = (inout T) -> ()

// MARK: - Assert Associative

public func AssertAssociative<T: CRDT & Equatable>(
    make: Make<T>,
    mutate: Mutate<T>,
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

public func AssertAssociative<T: CRDT, V: Equatable>(
    validating keyPath: KeyPath<T, V>,
    make: Make<T>,
    mutate: Mutate<T>,
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

// MARK: - Assert Commutative

public func AssertCommutative<T: CRDT & Equatable>(
    make: Make<T>,
    mutate: Mutate<T>,
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

public func AssertCommutative<T: CRDT, V: Equatable>(
    validating keyPath: KeyPath<T, V>,
    make: Make<T>,
    mutate: Mutate<T>,
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

        mutate(&a)
        mutate(&b)
        assert(a, b)
    }
}

// MARK: - Assert Idempotent

public func AssertIdempotent<T: CRDT & Equatable>(
    make: Make<T>,
    mutate: Mutate<T>,
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

public func AssertIdempotent<T: CRDT, V: Equatable>(
    validating keyPath: KeyPath<T, V>,
    make: Make<T>,
    mutate: Mutate<T>,
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
