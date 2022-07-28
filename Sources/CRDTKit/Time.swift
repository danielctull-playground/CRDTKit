
/// An implementation of a Lamport timestamp.
public struct Time: Equatable {
    private let rawValue: Int

    fileprivate init(_ rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension Time {

    public static let zero = Time(0)

    public mutating func increment() {
        self = Time(rawValue + 1)
    }
}

extension Time: Comparable {

    public static func < (lhs: Time, rhs: Time) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
