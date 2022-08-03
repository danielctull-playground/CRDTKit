
/// Performs the given closure ``count`` amount of times.
///
/// - Parameters:
///   - amount: The amount of times to call ``function``.
///   - function: A closure to be called.
public func loop(_ amount: Int, function: () -> Void) {
    guard amount > 0 else { return }
    for _ in 0..<amount { function() }
}
