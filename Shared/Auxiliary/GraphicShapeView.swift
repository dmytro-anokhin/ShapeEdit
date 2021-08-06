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
                ZStack {
                    if let fill = graphic.fill {
                        Rectangle()
                            .fill(fill.color)
                    }

                    if let stroke = graphic.stroke {
                        Rectangle()
                            .stroke(stroke.color)
                    }
                }

            case .triangle:
                ZStack {
                    if let fill = graphic.fill {
                        Triangle()
                            .fill(fill.color)
                    }

                    if let stroke = graphic.stroke {
                        Triangle()
                            .stroke(stroke.color)
                    }
                }

            case .ellipse:
                ZStack {
                    if let fill = graphic.fill {
                        Ellipse()
                            .fill(fill.color)
                    }

                    if let stroke = graphic.stroke {
                        Ellipse()
                            .stroke(stroke.color)
                    }
                }
        }
    }
}

struct GraphicShapeView_Previews: PreviewProvider {
    static var previews: some View {
        GraphicShapeView(graphic: Graphic.test.first!)
    }
}
