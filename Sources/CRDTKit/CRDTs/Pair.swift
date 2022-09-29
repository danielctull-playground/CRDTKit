
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
        fileprivate let kind: Kind
        fileprivate enum Kind {
            case a(A.Operation)
            case b(B.Operation)
        }
    }

    public func operation(_ operation: (A) -> A.Operation) -> Operation {
        Operation(kind: .a(operation(a)))
    }

    public func operation(_ operation: (B) -> B.Operation) -> Operation {
        Operation(kind: .b(operation(b)))
    }

    public struct Transaction {
        fileprivate let kind: Kind
        fileprivate enum Kind {
            case a(A.Transaction)
            case b(B.Transaction)
        }
    }

    public func transaction(site: Site, operation: Operation) -> Transaction {
        switch operation.kind {
        case let .a(operation):
            return Transaction(kind: .a(a.transaction(site: site, operation: operation)))
        case let .b(operation):
            return Transaction(kind: .b(b.transaction(site: site, operation: operation)))
        }
    }

    public var transactions: [Transaction] {
        let a = a.transactions.map { Transaction.Kind.a($0) }
        let b = b.transactions.map { Transaction.Kind.b($0) }
        return (a + b).map(Transaction.init)
    }

    public mutating func apply(_ transaction: Transaction) {
        switch transaction.kind {
        case let .a(transaction): a.apply(transaction)
        case let .b(transaction): b.apply(transaction)
        }
    }

    public func transaction(_ a: A.Transaction) -> Transaction {
        Transaction(kind: .a(a))
    }

    public func transaction(_ b: B.Transaction) -> Transaction {
        Transaction(kind: .b(b))
    }
}
