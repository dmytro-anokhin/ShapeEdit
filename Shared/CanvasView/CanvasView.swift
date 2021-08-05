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

    var body: some View {
        AdvancedScrollView(magnification: Magnification(range: 1.0...4.0, initialValue: 1.0, isRelative: false)) { proxy in
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
                    guard let graphic = graphics.hitTest(location, extendBy: SelectionProxy.radius) else {
                        return false
                    }

                    let selectionProxy = SelectionProxy(graphic: graphic)

                    // Location in selection proxy coordinates
                    let translatedLocation = CGPoint(
                        x: location.x - (selectionProxy.position.x),
                        y: location.y - (selectionProxy.position.y))

                    let direction = selectionProxy.hitTest(translatedLocation)

                    dragInfo = DragInfo(translation: translation, direction: direction)

                case .changed:
                    dragInfo?.translation = translation

                case .cancelled:
                    dragInfo = nil

                case .ended:
                    if let dragInfo = dragInfo {
                        for id in selection {
                            graphics.update(id) { graphic in
                                graphic.offset = dragInfo.translatedOffset(graphic.offset)
                                graphic.size = dragInfo.translatedSize(graphic.size)
                            }
                        }
                    }

                    dragInfo = nil
            }

            return true
        }
    }

    //@ViewBuilder
    var canvas: some View {
        let selections: [SelectionProxy] = graphics.flatten.compactMap { graphic in
            if selection.contains(graphic.id) {
                return SelectionProxy(graphic: graphic)
            } else {
                return nil
            }
        }

        return ZStack(alignment: .topLeading) {

            // Grid

            GridView(size: canvasSize)

            // Graphics

            ForEach($graphics) { graphic in
                makeTreeView(root: graphic.wrappedValue)
            }

            // Selection overlay
            ForEach(selections) { proxy in
                if let dragInfo = dragInfo, selection.contains(proxy.id) {
                    SelectionView(proxy: proxy)
                        .frame(size: dragInfo.translatedSize(proxy.selectionBounds.size))
                        .position(dragInfo.translatedPosition(proxy.selectionPosition, proxy.selectionBounds.size))
                } else {
                    SelectionView(proxy: proxy)
                        .frame(width: proxy.selectionBounds.width,
                               height: proxy.selectionBounds.height)
                        .position(x: proxy.selectionPosition.x + proxy.selectionBounds.width * 0.5,
                                  y: proxy.selectionPosition.y + proxy.selectionBounds.height * 0.5)
                }
            }
        }
    }

    @ViewBuilder func makeTreeView(root: Graphic) -> some View {
        ForEach(root.flatten) { node in
            makeView(node)
        }
    }

    @ViewBuilder func makeView(_ graphic: Graphic) -> some View {
        if let dragInfo = dragInfo, selection.contains(graphic.id) {
            GraphicShapeView(graphic: graphic)
                .frame(size: dragInfo.translatedSize(graphic.size))
                .position(dragInfo.translatedPosition(graphic))
        } else {
            GraphicShapeView(graphic: graphic)
                .frame(size: graphic.size)
                .position(x: graphic.offset.x + graphic.size.width * 0.5,
                          y: graphic.offset.y + graphic.size.height * 0.5)
        }
    }
}
