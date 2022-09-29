
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

// MARK: - CmRDT

extension GCounter: CmRDT {

    public struct Operation {
        fileprivate let value: Max<Value>
    }

    public struct Transaction {
        fileprivate let site: Site
        fileprivate let value: Max<Value>
    }

    public func transaction(site: Site, operation: Operation) -> Transaction {
        Transaction(site: site, value: operation.value)
    }

    public var transactions: [Transaction] {
        storage.map(Transaction.init)
    }

    public mutating func apply(_ transaction: Transaction) {
        storage.merge([transaction.site: transaction.value]) { $0.merging($1) }
    }

    public func transaction(increment: Value, site: Site? = nil) -> Transaction {
        let site = site ?? self.site
        let value = storage[site, default: Max(.zero)].value
        return Transaction(site: site, value: Max(value + increment))
    }
}

// MARK: - Codable

extension GCounter: Decodable where Value: Decodable {}
extension GCounter: Encodable where Value: Encodable {}
