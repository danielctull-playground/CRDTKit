
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
//        AssertAssociative { Max(Int.random) } operation: { .update(.random) }
//        AssertCommutative { Max(Int.random) } mutate: { $0.value = .random }
//        AssertIdempotent { Max(Int.random) } operation: { .update(.random) }
    }
}
