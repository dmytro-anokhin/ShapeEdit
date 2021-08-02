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

    @State private var dragInfo: DragInfo? = nil

    private struct DragInfo {

        var selection: Graphic

        var translation: CGSize
    }

    var body: some View {
        AdvancedScrollView { proxy in
            canvas
                .frame(width: canvasSize.width, height: canvasSize.height)
        }.onTapContentGesture { location, proxy in
            guard let graphic = graphics.hitTest(location) else {
                return
            }

            print("\(graphic.content) \(graphic.id)")
        }
        .onDragContentGesture { phase, location, translation, proxy in
            switch phase {
                case .possible:
                    return graphics.hitTest(location) != nil

                case .began:
                    guard let graphic = graphics.hitTest(location) else {
                        return false
                    }

                    dragInfo = DragInfo(selection: graphic, translation: translation)

                case .changed:
                    dragInfo?.translation = translation

                case .cancelled:
                    dragInfo = nil

                case .ended:
                    if let dragInfo = dragInfo {
                        graphics.update(dragInfo.selection.id) { graphic in
                            graphic.offset = CGPoint(x: graphic.offset.x + dragInfo.translation.width,
                                                     y: graphic.offset.y + dragInfo.translation.height)
                        }
                    }

                    dragInfo = nil
            }

            return true
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
        .position(position(graphic))
    }

    private func position(_ graphic: Graphic) -> CGPoint {
        var position = CGPoint(x: graphic.offset.x + graphic.size.width * 0.5,
                               y: graphic.offset.y + graphic.size.height * 0.5)

        if let dragInfo = dragInfo, graphic.id == dragInfo.selection.id {
            position.x += dragInfo.translation.width
            position.y += dragInfo.translation.height
        }

        return position
    }
}
