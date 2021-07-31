//
//  CanvasView.swift
//  ShapeEdit
//
//  Created by Dmytro Anokhin on 23/07/2021.
//

import SwiftUI
import AdvancedScrollView


struct CanvasView: View {

    @Binding var graphics: [Graphic]

    @State var canvasSize = CGSize(width: 1920.0, height: 1080.0)

//    private var graphicsCollection: BindingCollection<[Graphic]> {
//        BindingCollection(base: $graphics)
//    }

    var body: some View {
        AdvancedScrollView { proxy in
            canvas
                .frame(width: canvasSize.width, height: canvasSize.height)
        }
    }

    @ViewBuilder var canvas: some View {
        ZStack(alignment: .topLeading) {
            
            GridView(size: canvasSize)

            ForEach($graphics) { graphic in
                makeTreeView(root: graphic.wrappedValue)
            }
        }
    }

    @ViewBuilder func makeTreeView(root: Graphic) -> some View {
        ForEach(root.flatten) { node in
            makeView(node)
        }
    }

    @ViewBuilder func makeView(_ graphic: Graphic) -> some View {
        ZStack(alignment: .topLeading) {
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
        .frame(width: graphic.size.width, height: graphic.size.height)
        .position(x: graphic.offset.x + graphic.size.width * 0.5,
                  y: graphic.offset.y + graphic.size.height * 0.5)
    }
}
