
/// Operation-based CRDT: Commutative Replicated Data Type.
public protocol CmRDT: CvRDT {
    associatedtype Operation
    var operations: [Operation] { get }
    mutating func apply(_ operation: Operation)
}

extension CmRDT {

    public func applying(_ operation: Operation) -> Self {
        var copy = self
        copy.apply(operation)
        return copy
    }
}

extension CmRDT {

    public mutating func merge(_ other: Self) {
        for operation in other.operations {
            apply(operation)
        }
    }
}
