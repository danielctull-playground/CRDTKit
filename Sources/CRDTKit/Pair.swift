
public struct Pair<A, B> {
    public var a: A
    public var b: B

    public init(_ a: A, _ b: B) {
        self.a = a
        self.b = b
    }
}

extension Pair: Equatable where A: Equatable, B: Equatable {}

extension Pair: CvRDT where A: CvRDT, B: CvRDT {

    public mutating func merge(_ other: Pair<A, B>) {
        a.merge(other.a)
        b.merge(other.b)
    }
}

extension Pair: CmRDT where A: CmRDT, B: CmRDT {

    public struct Operation {
        let kind: Kind
        enum Kind {
            case a(A.Operation)
            case b(B.Operation)
        }
    }

    public var operations: [Operation] {
        let a = a.operations.map { Operation.Kind.a($0) }
        let b = b.operations.map { Operation.Kind.b($0) }
        return (a + b).map(Operation.init)
    }

    public mutating func apply(_ operation: Operation) {
        switch operation.kind {
        case let .a(operation): a.apply(operation)
        case let .b(operation): b.apply(operation)
        }
    }
}
