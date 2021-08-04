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

    private var selections: [SelectionProxy]

    init(graphics: Binding<[Graphic]>, selection: Binding<Set<String>>) {
        self._graphics = graphics
        self._selection = selection

        selections = graphics.wrappedValue.flatten.compactMap { graphic in
            if selection.wrappedValue.contains(graphic.id) {
                return SelectionProxy(graphic: graphic)
            } else {
                return nil
            }
        }
    }

    var body: some View {
        AdvancedScrollView { proxy in
            canvas
                .frame(width: canvasSize.width, height: canvasSize.height)
        }.onTapContentGesture { location, proxy in
            selection.removeAll()

            if let graphic = graphics.hitTest(location, extendBy: 0.0) {
                //selection.formUnion(graphic.flatten.map({ $0.id }))
                selection.insert(graphic.id)
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
                    guard let graphic = graphics.hitTest(location) else {
                        return false
                    }

                    let selectionProxy = SelectionProxy(graphic: graphic)
                    let direction = selectionProxy.hitTest(location)

                    dragInfo = DragInfo(translation: translation, direction: direction)

                case .changed:
                    dragInfo?.translation = translation

                case .cancelled:
                    dragInfo = nil

                case .ended:
                    for id in selection {
                        graphics.update(id) { graphic in
                            graphic.offset = translatedOffset(graphic)
                            graphic.size = translatedSize(graphic)
                        }
                    }

                    dragInfo = nil
            }

            return true
        }
    }

    @ViewBuilder var canvas: some View {
        ZStack(alignment: .topLeading) {

            // Grid

            GridView(size: canvasSize)

            // Graphics

            ForEach($graphics) { graphic in
                makeTreeView(root: graphic.wrappedValue)
            }

            // Selection overlay
            ForEach(selections) { proxy in
                SelectionView(proxy: proxy)
                    .frame(width: proxy.selectionBounds.width,
                           height: proxy.selectionBounds.height)
                    .position(x: proxy.selectionPosition.x,
                              y: proxy.selectionPosition.y)
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
            GraphicShapeView(graphic: graphic)
        }
        .frame(size: translatedSize(graphic))
        .position(translatedPosition(graphic))
    }

    private func translatedPosition(_ graphic: Graphic) -> CGPoint {
        let size = translatedSize(graphic)
        let offset = translatedOffset(graphic)

        return CGPoint(x: offset.x + size.width * 0.5,
                       y: offset.y + size.height * 0.5)
    }

    private func translatedOffset(_ graphic: Graphic) -> CGPoint {
        var offset = graphic.offset

        if let dragInfo = dragInfo, selection.contains(graphic.id) {
            if let direction = dragInfo.direction {
                switch direction {
                    case .top:
                        offset.y += dragInfo.translation.height

                    case .topLeft:
                        offset.x += dragInfo.translation.width
                        offset.y += dragInfo.translation.height

                    case .left:
                        offset.x += dragInfo.translation.width

                    case .bottomLeft:
                        offset.x += dragInfo.translation.width

                    case .bottom:
                        break

                    case .bottomRight:
                        break

                    case .right:
                        break

                    case .topRight:
                        offset.y += dragInfo.translation.height
                }
            } else {
                offset.x += dragInfo.translation.width
                offset.y += dragInfo.translation.height
            }
        }

        return offset
    }

    private func translatedSize(_ graphic: Graphic) -> CGSize {
        var size = graphic.size

        if let dragInfo = dragInfo,
           selection.contains(graphic.id),
           let direction = dragInfo.direction {

            switch direction {
                case .top:
                    size.height -= dragInfo.translation.height

                case .topLeft:
                    size.width -= dragInfo.translation.width
                    size.height -= dragInfo.translation.height

                case .left:
                    size.width -= dragInfo.translation.width

                case .bottomLeft:
                    size.width -= dragInfo.translation.width
                    size.height += dragInfo.translation.height

                case .bottom:
                    size.height += dragInfo.translation.height

                case .bottomRight:
                    size.width += dragInfo.translation.width
                    size.height += dragInfo.translation.height

                case .right:
                    size.width += dragInfo.translation.width

                case .topRight:
                    size.width += dragInfo.translation.width
                    size.height -= dragInfo.translation.height
            }
        }

        return size
    }
}
