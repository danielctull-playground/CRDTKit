
import CRDTKit
import SwiftUI

public struct YarnView<Value, Content: View>: View {

    private let yarn: Yarn<Value>
    private let content: (Value) -> Content

    public init(yarn: Yarn<Value>, content: @escaping (Value) -> Content) {
        self.yarn = yarn
        self.content = content
    }

    public var body: some View {
        HStack {
            ForEach(yarn.atoms) { atom in
                AtomView(atom: atom, content: content)
            }
        }
    }
}
