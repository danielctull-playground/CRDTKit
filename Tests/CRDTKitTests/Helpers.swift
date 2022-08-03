
extension Int {

    /// A random integer between -10,000 and 10,000.
    ///
    /// This is limited to prevent overflows on addition.
    static var random: Int { .random(in: -10_000..<10_000) }
}
