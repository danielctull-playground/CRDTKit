
public struct Yarn<Value> {

    public let site: Site
    public var atoms: [Atom<Value>]

    public init(site: Site, atoms: [Atom<Value>] = []) {
        self.site = site
        self.atoms = atoms
    }

    public func addAtom(_ atom: Atom<Value>) {
        assert(atom.id.site == site)
    }
}
