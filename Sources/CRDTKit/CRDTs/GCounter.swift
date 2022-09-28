
import Foundation

public struct GCounter<Value: Comparable & AdditiveArithmetic>: Equatable {

    private var storage: [Site: Max<Value>]
    private var site = Site()

    public init(_ value: Value) {
        self.storage = [site: Max(value)]
    }

    public var value: Value {
        storage.values.reduce(.zero) { $0 + $1.value }
    }

    public static func +=(lhs: inout Self, rhs: Value) {
        assert(rhs >= .zero, "GCounter cannot be decremented")
        lhs.storage[lhs.site, default: Max(.zero)].value += rhs
    }
}

// MARK: - CvRDT

extension GCounter: CvRDT {

    public mutating func merge(_ other: Self) {
        storage.merge(other.storage) { $0.merging($1) }
    }
}

// MARK: - Codable

extension GCounter: Decodable where Value: Decodable {}
extension GCounter: Encodable where Value: Encodable {}
