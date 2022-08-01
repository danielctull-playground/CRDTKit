
/// Performs the given closure ``count`` amount of times.
///
/// - Parameters:
///   - amount: The amount of times to call ``function``.
///   - function: A closure to be called.
func loop(_ amount: Int, function: () -> Void) {
    guard amount > 0 else { return }
    for _ in 0..<amount { function() }
}

extension Int {

    /// A random integer between -10,000 and 10,000.
    ///
    /// This is limited to prevent overflows on addition.
    static var random: Int { .random(in: -10_000..<10_000) }
}
