
public struct Max<Value: Comparable>: Equatable {

    public var value: Value

    public init(_ value: Value) {
        self.value = value
    }
}

// MARK: - CvRDT

extension Max: CvRDT {

    public mutating func merge(_ other: Max<Value>) {
        value = max(value, other.value)
    }
}

// MARK: - CmRDT

extension Max: CmRDT {

    public struct Operation {
        let value: Value
        public init(_ value: Value) {
            self.value = value
        }
    }

    public mutating func apply(_ operation: Operation) {
        value = max(value, operation.value)
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
