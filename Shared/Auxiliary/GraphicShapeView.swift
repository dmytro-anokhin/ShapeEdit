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

                    if let stroke = graphic.stroke, stroke.lineWidth > 0.0 {
                        Rectangle()
                            .stroke(stroke.style.color, lineWidth: stroke.lineWidth)
                    }
                }

            case .triangle:
                ZStack {
                    if let fill = graphic.fill {
                        Triangle()
                            .fill(fill.color)
                    }

                    if let stroke = graphic.stroke, stroke.lineWidth > 0.0 {
                        Triangle()
                            .stroke(stroke.style.color, lineWidth: stroke.lineWidth)
                    }
                }

            case .ellipse:
                ZStack {
                    if let fill = graphic.fill {
                        Ellipse()
                            .fill(fill.color)
                    }

                    if let stroke = graphic.stroke, stroke.lineWidth > 0.0 {
                        Ellipse()
                            .stroke(stroke.style.color, lineWidth: stroke.lineWidth)
                    }
                }
        }
    }
}

struct GraphicShapeView_Previews: PreviewProvider {
    static var previews: some View {
        GraphicShapeView(graphic: Graphic.smallSet.first!)
    }
}
