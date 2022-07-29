
/// Performs the given closure ``count`` amount of times.
///
/// - Parameters:
///   - count: The amount of times to call ``function``.
///   - function: A closure to be called.
func loop(_ count: Int, function: () -> Void) {
    guard count > 0 else { return }
    for _ in 0..<count { function() }
}

extension Int {

    /// A random integer between -10,000 and 10,000.
    ///
    /// This is limited to prevent overflows on addition.
    static var random: Int { .random(in: -10_000..<10_000) }
}
