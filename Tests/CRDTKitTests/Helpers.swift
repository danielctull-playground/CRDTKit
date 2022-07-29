
/// Performs the given closure ``count`` amount of times.
///
/// - Parameters:
///   - count: The amount of times to call ``function``.
///   - function: A closure to be called.
func loop(_ count: Int, function: () -> Void) {
    guard count > 0 else { return }
    for _ in 0..<count { function() }
}
