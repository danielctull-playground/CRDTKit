
import Foundation

public struct Site: Equatable, Hashable {
    private let rawValue: String

    fileprivate init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

extension Site {

    public init() {
        self.init(UUID().uuidString)
    }
}

extension Site: ExpressibleByStringLiteral {

    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}

extension Site: Comparable {

    public static func < (lhs: Site, rhs: Site) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension Site: CustomStringConvertible {

    public var description: String { rawValue }
}

extension Site: Decodable {

    public init(from decoder: Decoder) throws {
        rawValue = try String(from: decoder)
    }
}

extension Site: Encodable {

    public func encode(to encoder: Encoder) throws {
        try rawValue.encode(to: encoder)
    }
}
