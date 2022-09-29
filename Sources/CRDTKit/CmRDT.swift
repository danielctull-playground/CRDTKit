
/// Operation-based CRDT: Commutative Replicated Data Type.
public protocol CmRDT: CvRDT {
    associatedtype Transaction
    associatedtype Operation
    var transactions: [Transaction] { get }
    mutating func apply(_ transaction: Transaction)
    func transaction(site: Site, operation: Operation) -> Transaction
}

extension CmRDT {

    public mutating func apply(_ transactions: [Transaction]) {
        for transaction in transactions {
            apply(transaction)
        }
    }

    public func applying(_ transaction: Transaction) -> Self {
        var copy = self
        copy.apply(transaction)
        return copy
    }

    public func applying(_ transactions: [Transaction]) -> Self {
        var copy = self
        copy.apply(transactions)
        return copy
    }
}

extension CmRDT {

    public mutating func merge(_ other: Self) {
        for transaction in other.transactions {
            apply(transaction)
        }
    }
}
