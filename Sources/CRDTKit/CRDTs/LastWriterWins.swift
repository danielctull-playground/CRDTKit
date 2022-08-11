
public struct LastWriterWins<Value> {

    private var site: Site
    private var time: Time

    public init(_ value: Value, site: Site = Site(), time: Time = .zero) {
        self.value = value
        self.site = site
        self.time = time
    }

    public private(set) var value: Value

    public mutating func setValue(_ newValue: Value, site newSite: Site) {
        value = newValue
        site = newSite
        time.increment()
    }
}

extension LastWriterWins: Equatable where Value: Equatable {}
extension LastWriterWins: Hashable where Value: Hashable {}

// MARK: - CmRDT

extension LastWriterWins: CmRDT {

    public struct Operation {
        fileprivate let site: Site
        fileprivate let time: Time
        fileprivate let value: Value
    }

    public var operations: [Operation] {
        [Operation(site: site, time: time, value: value)]
    }

    public mutating func apply(_ operation: Operation) {
        guard (operation.time, operation.site) > (time, site) else { return }
        value = operation.value
        time = operation.time
        site = operation.site
    }
}

// MARK: - Codable

extension LastWriterWins: Decodable where Value: Decodable {}
extension LastWriterWins: Encodable where Value: Encodable {}
extension LastWriterWins.Operation: Decodable where Value: Decodable {}
extension LastWriterWins.Operation: Encodable where Value: Encodable {}

// MARK: - CustomDebugStringConvertible

extension LastWriterWins: CustomDebugStringConvertible {

    public var debugDescription: String {
        "LWW(value: \(value), site: \(site), time: \(time))"
    }
}
