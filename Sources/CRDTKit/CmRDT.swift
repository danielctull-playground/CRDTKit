
/// Operation-based CRDT: Commutative Replicated Data Type.
public protocol CmRDT: CvRDT {
    associatedtype Operation
    var operations: [Operation] { get }
    mutating func apply(_ operation: Operation)
}

extension CmRDT {

    public mutating func apply(_ operations: [Operation]) {
        for operation in operations {
            apply(operation)
        }
    }

    public func applying(_ operation: Operation) -> Self {
        var copy = self
        copy.apply(operation)
        return copy
    }

    public func applying(_ operations: [Operation]) -> Self {
        var copy = self
        copy.apply(operations)
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
