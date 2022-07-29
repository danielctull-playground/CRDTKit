
public struct GrowOnlySet<Element: Hashable>: Equatable {

    private var elements: Set<Element>

    public init(_ elements: Set<Element> = []) {
        self.elements = elements
    }
}

// MARK: - Set Operations

extension GrowOnlySet {

    @discardableResult
    public mutating func insert(
        _ newMember: Element
    ) -> (inserted: Bool, memberAfterInsert: Element) {
        elements.insert(newMember)
    }

    public mutating func formUnion(_ other: GrowOnlySet) {
        elements.formUnion(other.elements)
    }
}

// MARK: - Collection

extension GrowOnlySet: Collection {

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

// MARK: - CRDT

extension GrowOnlySet: CRDT {

    public mutating func merge(_ other: GrowOnlySet) {
        formUnion(other)
    }
}
