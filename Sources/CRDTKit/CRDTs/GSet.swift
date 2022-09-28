
/// A Grow-Only Set
public struct GSet<Element: Hashable>: Equatable {
    private var elements: Set<Element>
}

extension GSet {

    public init() {
        self.init(elements: [])
    }

    public init<S: Sequence>(_ sequence: S) where S.Element == Element {
        self.init(elements: Set(sequence))
    }
}

// MARK: - Set Operations

extension GSet {

    @discardableResult
    public mutating func insert(
        _ newMember: Element
    ) -> (inserted: Bool, memberAfterInsert: Element) {
        elements.insert(newMember)
    }

    public mutating func formUnion(_ other: GSet) {
        elements.formUnion(other.elements)
    }
}

// MARK: - Codable

extension GSet: Decodable where Element: Decodable {

    public init(from decoder: Decoder) throws {
        try self.init(elements: Set(from: decoder))
    }
}

extension GSet: Encodable where Element: Encodable {

    public func encode(to encoder: Encoder) throws {
        try elements.encode(to: encoder)
    }
}

// MARK: - ExpressibleByArrayLiteral

extension GSet: ExpressibleByArrayLiteral {

    public init(arrayLiteral elements: Element...) {
        self.init(elements: Set(elements))
    }
}

// MARK: - Sequence

extension GSet: Sequence {

    /// The number of elements in the set.
    ///
    /// - Complexity: O(1)
    public var count: Int { elements.count }

    /// Returns a Boolean value that indicates whether the given element exists
    /// in the set.
    ///
    /// - Parameter member: An element to look for in the set.
    /// - Returns: `true` if member exists in the set; otherwise, `false`.
    /// - Complexity: O(1)
    public func contains(_ member: Element) -> Bool {
        elements.contains(member)
    }
}

// MARK: - Collection

extension GSet: Collection {

    public struct Index: Comparable {
        fileprivate let index: Set<Element>.Index
        fileprivate init(_ index: Set<Element>.Index) {
            self.index = index
        }
        public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.index < rhs.index
        }
    }

    public var startIndex: Index { Index(elements.startIndex) }

    public var endIndex: Index { Index(elements.endIndex) }

    public func index(after i: Index) -> Index {
        Index(elements.index(after: i.index))
    }

    public subscript(position: Index) -> Element {
        elements[position.index]
    }
}

// MARK: - CvRDT

extension GSet: CvRDT {

    public mutating func merge(_ other: GSet) {
        formUnion(other)
    }
}
