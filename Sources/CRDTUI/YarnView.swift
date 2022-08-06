
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

extension YarnView where Value: CustomStringConvertible, Content == Text {

    public init(yarn: Yarn<Value>) {
        self.yarn = yarn
        self.content = { value in
            Text(value.description)
        }
    }
}

struct YarnView_Previews: PreviewProvider {

    static var previews: some View {

        let zero = AtomID(site: "Daniel", time: .zero)
        let one = AtomID(site: "Daniel", time: .zero.incremented)
        let two = AtomID(site: "Daniel", time: .zero.incremented.incremented)
        let three = AtomID(site: "Daniel", time: .zero.incremented.incremented.incremented)

        YarnView(yarn: Yarn(site: "", atoms: [
            Atom(id: zero, value: "Change One"),
            Atom(id: one, parent: zero, value: "Change Two"),
            Atom(id: two, parent: one, value: "Change Three"),
            Atom(id: three, parent: two, value: "Change Four"),
        ]))
    }
}
