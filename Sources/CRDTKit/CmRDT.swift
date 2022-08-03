
/// Operation-based CRDT: Commutative Replicated Data Type.
public protocol CmRDT {
    associatedtype Operation
    mutating func apply(_ operation: Operation)
}

extension CmRDT {

    public func applying(_ operation: Operation) -> Self {
        var copy = self
        copy.apply(operation)
        return copy
    }
}
