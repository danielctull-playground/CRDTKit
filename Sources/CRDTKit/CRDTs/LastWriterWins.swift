
public struct LastWriterWins<Value> {

    private var site: Site
    private var time: Time

    public init(_ value: Value, site: Site = Site(), time: Time = .zero) {
        self.value = value
        self.site = site
        self.time = time
    }

    public var value: Value {
        didSet { time.increment() }
    }
}

extension LastWriterWins: Decodable where Value: Decodable {}
extension LastWriterWins: Encodable where Value: Encodable {}
extension LastWriterWins: Equatable where Value: Equatable {}
extension LastWriterWins: Hashable where Value: Hashable {}

// MARK: - CvRDT

extension LastWriterWins: CvRDT {

    public mutating func merge(_ other: Self) {
        guard (other.time, other.site) > (time, site) else { return }
        value = other.value
        time = other.time
    }
}

extension LastWriterWins: CustomDebugStringConvertible {

    public var debugDescription: String {
        "LWW(value: \(value), site: \(site), time: \(time))"
    }
}
