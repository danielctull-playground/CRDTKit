
public struct Max<Value: Comparable>: Equatable {

    public var value: Value

    public init(_ value: Value) {
        self.value = value
    }
}

// MARK: - CmRDT

extension Max: CmRDT {

    public struct Operation {
        fileprivate let value: Value
    }

    public var operations: [Operation] {
        [Operation(value: value)]
    }

    public mutating func apply(_ operation: Operation) {
        value = max(value, operation.value)
    }

    public func operation(value: Value) -> Operation {
        Operation(value: value)
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

extension Max.Operation: Decodable where Value: Decodable {

    public init(from decoder: Decoder) throws {
        try self.init(value: Value(from: decoder))
    }
}

extension Max.Operation: Encodable where Value: Encodable {

    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}
