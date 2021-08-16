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
                    guard !selection.isEmpty else {
                        return false
                    }

                    let selected = graphics.recursiveFilter {
                        selection.contains($0.id)
                            && $0.hitTest(location, includeChildren: false, extendBy: SelectionProxy.radius) != nil
                    }

                    return !selected.isEmpty

                case .began:
                    guard !selection.isEmpty else {
                        return false
                    }

                    dragInfo = DragInfo(translation: translation, direction: nil)

                    let selected = graphics.recursiveFilter {
                        selection.contains($0.id)
                            && $0.hitTest(location, includeChildren: false, extendBy: SelectionProxy.radius) != nil
                    }

                    for graphic in selected {
                        let selectionProxy = SelectionProxy(graphic: graphic)

                        if let direction = selectionProxy.hitTest(location) {
                            dragInfo = DragInfo(translation: translation, direction: direction)
                            break
                        }
                    }

                case .changed:
                    dragInfo?.translation = translation

                case .cancelled:
                    dragInfo = nil

                case .ended:
                    if let dragInfo = dragInfo {
                        for id in selection {
                            graphics.update(id) { graphic in
                                graphic.offset = dragInfo.translatedPoint(graphic.offset)
                                graphic.size = dragInfo.translatedSize(graphic.size)
                            }
                        }
                    }

                    dragInfo = nil
            }

            return true
        }
    }

    private var selections: [SelectionProxy] {
        graphics.flatten.compactMap { graphic in
            if selection.contains(graphic.id) {
                return SelectionProxy(graphic: graphic)
            } else {
                return nil
            }
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
                if let dragInfo = dragInfo, selection.contains(proxy.id) {
                    SelectionView(proxy: proxy)
                        .frame(rect: dragInfo.translatedFrame(proxy.selectionFrame))
                } else {
                    SelectionView(proxy: proxy)
                        .frame(rect: proxy.selectionFrame)
                }
            }
        }
    }

    @ViewBuilder func makeTreeView(root: Graphic) -> some View {
        ForEach(root.flatten) { node in
            makeView(node)
                .contextMenu {
                    Button {
                        graphics.remove(node)
                    } label: {
                        Text("Delete")
                    }
                }
        }
    }

    @ViewBuilder func makeView(_ graphic: Graphic) -> some View {
        if let dragInfo = dragInfo, selection.contains(graphic.id) {
            GraphicShapeView(graphic: graphic)
                .frame(rect: dragInfo.translatedFrame(graphic))
        } else {
            GraphicShapeView(graphic: graphic)
                .frame(rect: graphic.frame)
        }
    }
}
