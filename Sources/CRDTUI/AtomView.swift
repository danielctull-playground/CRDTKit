
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
        VStack(spacing: 0) {

            Text(atom.id.description)
                .padding(4)
                .background(.yellow)
                .border(.black)

            content(atom.value)
                .padding(4)

            if let parent = atom.parent {
                Text(parent.description)
                    .padding(.horizontal, 4)
                    .padding(.bottom, 4)
            } else {
                Text("ø")
                    .padding(.horizontal, 4)
                    .padding(.bottom, 4)
            }
        }
        .mask {
            RoundedRectangle(cornerRadius: 6)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 6)
                .strokeBorder(Color.black)
        }
    }
}

extension AtomView where Value: CustomStringConvertible, Content == Text {

    public init(atom: Atom<Value>) {
        self.atom = atom
        self.content = { value in
            Text(value.description)
        }
    }
}

struct AtomView_Previews: PreviewProvider {

    static var previews: some View {
        AtomView(atom: Atom(id: AtomID(site: "Daniel", time: .zero), value: "Hello"))
    }
}
