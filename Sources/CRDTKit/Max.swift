
public struct Max<Value: Comparable>: Equatable {

    public var value: Value

    public init(_ value: Value) {
        self.value = value
    }
}

extension Max: CRDT {

    public mutating func merge(_ other: Max<Value>) {
        value = max(value, other.value)
    }
}
