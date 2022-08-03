
/// State-based CRDT: Convergent Replicated Data Type.
///
/// CvRDT requires a `merge` function that's associative, commutative and
/// idempotent.
///
/// - Associative:
///   `a.merge(b).merge(c) == a.merge(b.merge(c))`
/// - Commutative:
///   `a.merge(b) == b.merge(a)`
/// - Idempotent:
///   `a.merge(a) == a`
public protocol CvRDT {
    mutating func merge(_ other: Self)
}

extension CvRDT {

    public func merging(_ other: Self) -> Self {
        var copy = self
        copy.merge(other)
        return copy
    }
}
