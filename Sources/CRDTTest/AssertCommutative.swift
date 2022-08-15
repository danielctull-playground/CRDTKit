
import CRDTKit
import XCTest

// MARK: - CmRDT

public func AssertCommutative<T: CmRDT & Equatable>(
    make: () -> T,
    operation: (T) -> T.Operation,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    AssertCommutative(
        validating: \.self,
        make: make,
        operation: operation,
        file: file,
        line: line)
}

public func AssertCommutative<T: CmRDT, V: Equatable>(
    validating keyPath: KeyPath<T, V>,
    make: () -> T,
    operation: (T) -> T.Operation,
    file: StaticString = #filePath,
    line: UInt = #line
) {

    func assert(_ a: T, _ b: T) {
        XCTAssertEqual(
            a.applying(b.operations)[keyPath: keyPath],
            b.applying(a.operations)[keyPath: keyPath],
            "Not commutative.",
            file: file,
            line: line
        )
    }

    loop(1000) {
        var a = make()
        var b = make()
        assert(a, b)

        loop(.random(in: 1...10)) { a.apply(operation(a)) }
        loop(.random(in: 1...10)) { b.apply(operation(b)) }
        assert(a, b)
    }
}

// MARK: - CvRDT

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
