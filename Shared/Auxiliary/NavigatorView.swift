//
//  NavigatorView.swift
//  NavigatorView
//
//  Created by Dmytro Anokhin on 02/08/2021.
//

import SwiftUI


struct NavigatorView: View {

    var graphics: [Graphic]

    var body: some View {
        List(graphics, children: \.children) { graphic in
            HStack {
                GraphicContentView(graphic: graphic)
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(maxHeight: 17.0)
                Text(graphic.name)
            }
        }
        .listStyle(.sidebar)
    }
}


struct GraphicContentView: View {

    var graphic: Graphic

    var body: some View {
        switch graphic.content {
            case .rect:
                Rectangle()
                    .fill(graphic.fill.color)

            case .triangle:
                Triangle()
                    .fill(graphic.fill.color)

            case .circle:
                Circle()
                    .fill(graphic.fill.color)
        }
    }
}


struct NavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorView(graphics: Graphic.test)
    }
}
