//
//  NavigatorView.swift
//  NavigatorView
//
//  Created by Dmytro Anokhin on 02/08/2021.
//

import SwiftUI


struct NavigatorView: View {

    var graphics: [Graphic]

    @Binding var selection: Set<String>

    var body: some View {
        List(selection: $selection) {
            Section(header: Text("Canvas")) {
                OutlineGroup(graphics, children: \.children) {
                    GraphicRow($0)
                }
            }
        }
        .listStyle(.sidebar)
    }
}

extension NavigatorView {

    struct GraphicRow: View {

        var graphic: Graphic

        init(_ graphic: Graphic) {
            self.graphic = graphic
        }

        var body: some View {
            HStack {
                GraphicShapeView(graphic: graphic)
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(maxHeight: 17.0)
                Text(graphic.name)
            }.padding(.leading, 8.0)
        }
    }
}


struct NavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorView(graphics: Graphic.test, selection: .constant([]))
    }
}
