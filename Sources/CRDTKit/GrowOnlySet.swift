
public struct GrowOnlySet<Element: Hashable>: Equatable {
    public private(set) var elements: Set<Element>

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

// MARK: - CRDT

extension GrowOnlySet: CRDT {

    public mutating func merge(_ other: GrowOnlySet) {
        formUnion(other)
    }
}
