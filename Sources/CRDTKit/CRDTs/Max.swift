
public struct Max<Value: Comparable>: Equatable {

    public var value: Value

    public init(_ value: Value) {
        self.value = value
    }
}

// MARK: - CmRDT

extension Max: CmRDT {

    public struct Transaction {
        fileprivate let value: Value
    }

    public var transactions: [Transaction] {
        [Transaction(value: value)]
    }

    public mutating func apply(_ transaction: Transaction) {
        value = max(value, transaction.value)
    }

    public func transaction(value: Value) -> Transaction {
        Transaction(value: value)
    }
}

// MARK: - Codable

extension Max: Decodable where Value: Decodable {

    public init(from decoder: Decoder) throws {
        try self.init(Value(from: decoder))
    }
}

extension Max: Encodable where Value: Encodable {

    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}

extension Max.Transaction: Decodable where Value: Decodable {

    public init(from decoder: Decoder) throws {
        try self.init(value: Value(from: decoder))
    }
}

extension Max.Transaction: Encodable where Value: Encodable {

    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}
