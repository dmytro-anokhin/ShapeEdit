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

    @Binding var selection: Set<String>

    @State var canvasSize = CGSize(width: 1920.0, height: 1080.0)

    @State private var dragInfo: DragInfo? = nil

    private struct DragInfo {

        var translation: CGSize
    }

    var body: some View {
        AdvancedScrollView { proxy in
            canvas
                .frame(width: canvasSize.width, height: canvasSize.height)
        }.onTapContentGesture { location, proxy in
            selection.removeAll()

            if let graphic = graphics.hitTest(location) {
                selection.formUnion(graphic.flatten.map({ $0.id }))
            }
        }
        .onDragContentGesture { phase, location, translation, proxy in
            switch phase {
                case .possible:
                    guard let graphic = graphics.hitTest(location) else {
                        return false
                    }

                    return selection.contains(graphic.id)

                case .began:
                    dragInfo = DragInfo(translation: translation)

                case .changed:
                    dragInfo?.translation = translation

                case .cancelled:
                    dragInfo = nil

                case .ended:
                    if let dragInfo = dragInfo {
                        for id in selection {
                            graphics.update(id) { graphic in
                                graphic.offset = CGPoint(x: graphic.offset.x + dragInfo.translation.width,
                                                         y: graphic.offset.y + dragInfo.translation.height)
                            }
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
            if selection.contains(graphic.id) {
                SelectionView {
                    GraphicShapeView(graphic: graphic)
                }
            } else {
                GraphicShapeView(graphic: graphic)
            }
        }
        .frame(width: graphic.size.width, height: graphic.size.height)
        .position(position(graphic))
    }

    private func position(_ graphic: Graphic) -> CGPoint {
        var position = CGPoint(x: graphic.offset.x + graphic.size.width * 0.5,
                               y: graphic.offset.y + graphic.size.height * 0.5)

        if let dragInfo = dragInfo, selection.contains(graphic.id) {
            position.x += dragInfo.translation.width
            position.y += dragInfo.translation.height
        }

        return position
    }
}
