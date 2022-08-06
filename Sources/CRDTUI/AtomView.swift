
import CRDTKit
import SwiftUI

public struct AtomView<Value, Content: View>: View {

    private let atom: Atom<Value>
    private let content: (Value) -> Content

    public init(atom: Atom<Value>, content: @escaping (Value) -> Content) {
        self.atom = atom
        self.content = content
    }

    public var body: some View {
        VStack {
            content(atom.value)
        }
    }
}
