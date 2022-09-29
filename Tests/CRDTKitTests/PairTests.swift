
import CRDTKit
import CRDTTest
import XCTest

final class PairTests: XCTestCase {

    func testCvRDT() {

        AssertAssociative {
            Pair(Max(Int.random), Max(Int.random))
        } mutate: {
            if Bool.random() { $0.a.value = .random }
            if Bool.random() { $0.b.value = .random }
        }

        AssertCommutative {
            Pair(Max(Int.random), Max(Int.random))
        } mutate: {
            if Bool.random() { $0.a.value = .random }
            if Bool.random() { $0.b.value = .random }
        }

        AssertIdempotent {
            Pair(Max(Int.random), Max(Int.random))
        } mutate: {
            if Bool.random() { $0.a.value = .random }
            if Bool.random() { $0.b.value = .random }
        }
    }

    func testCmRDT() {

        AssertAssociative {
            Pair(Max(Int.random), LWWRegister(Int.random))
        } transaction: {
            if Bool.random() {
                return $0.transaction($0.a.transaction(value: .random))
            } else {
                return $0.transaction($0.b.transaction(value: .random))
            }
        }

        AssertCommutative {
            Pair(Max(Int.random), LWWRegister(Int.random))
        } transaction: {
            if Bool.random() {
                return $0.transaction($0.a.transaction(value: .random))
            } else {
                return $0.transaction($0.b.transaction(value: .random))
            }
        }

        AssertIdempotent {
            Pair(Max(Int.random), LWWRegister(Int.random))
        } transaction: {
            if Bool.random() {
                return $0.transaction($0.a.transaction(value: .random))
            } else {
                return $0.transaction($0.b.transaction(value: .random))
            }
        }
    }
}
