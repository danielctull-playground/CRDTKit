
public struct LWWRegister<Value> {

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

extension LWWRegister: Equatable where Value: Equatable {}
extension LWWRegister: Hashable where Value: Hashable {}

// MARK: - CmRDT

extension LWWRegister: CmRDT {

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

    public func operation(value: Value, site: Site? = nil) -> Operation {
        let site = site ?? self.site
        return Operation(site: site, time: time.incremented, value: value)
    }
}

// MARK: - Codable

extension LWWRegister: Decodable where Value: Decodable {}
extension LWWRegister: Encodable where Value: Encodable {}
extension LWWRegister.Operation: Decodable where Value: Decodable {}
extension LWWRegister.Operation: Encodable where Value: Encodable {}

// MARK: - CustomDebugStringConvertible

extension LWWRegister: CustomDebugStringConvertible {

    public var debugDescription: String {
        "LWW(value: \(value), site: \(site), time: \(time))"
    }
}
