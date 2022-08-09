
/// An implementation of a Lamport timestamp.
public struct Time: Equatable, Hashable {
    private let rawValue: Int

    fileprivate init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension Time {

    public static let zero = Time(0)

    public var incremented: Time { Time(rawValue + 1) }

    public mutating func increment() { self = incremented }
}

extension Time: Comparable {

    public static func < (lhs: Time, rhs: Time) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension Time: CustomStringConvertible {

    public var description: String { "\(rawValue)" }
}

extension Time: Decodable {

    public init(from decoder: Decoder) throws {
        rawValue = try Int(from: decoder)
    }
}

extension Time: Encodable {

    public func encode(to encoder: Encoder) throws {
        try rawValue.encode(to: encoder)
    }
}
