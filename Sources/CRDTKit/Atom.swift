
public struct Atom<Value> {
    public let id: AtomID
    public let parent: AtomID?
    public let value: Value

    public init(id: AtomID, parent: AtomID? = nil, value: Value) {
        self.id = id
        self.parent = parent
        self.value = value
    }
}

extension Atom: Equatable where Value: Equatable {}

// MARK: -

public struct AtomID: Equatable {
    public let site: Site
    public let time: Time

    public init(site: Site, time: Time) {
        self.site = site
        self.time = time
    }
}
