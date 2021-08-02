//
//  GraphicShapeView.swift
//  GraphicShapeView
//
//  Created by Dmytro Anokhin on 02/08/2021.
//

import SwiftUI

struct GraphicShapeView: View {

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

struct GraphicShapeView_Previews: PreviewProvider {
    static var previews: some View {
        GraphicShapeView(graphic: Graphic.test.first!)
    }
}
