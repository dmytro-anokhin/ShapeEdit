//
//  SelectionView.swift
//  SelectionView
//
//  Created by Dmytro Anokhin on 03/08/2021.
//

import SwiftUI


struct SelectionProxy: Identifiable {

    static let radius: CGFloat = 5.0

    /// Used for hit test
    static let extendedRadius: CGFloat = 15.0

    var id: String

    var offset: CGPoint

    var size: CGSize

    init(graphic: Graphic) {
        self.id = graphic.id
        self.offset = graphic.offset
        self.size = graphic.size
    }

    var graphicBounds: CGRect {
        CGRect(origin: .zero, size: size)
    }

    var graphicFrame: CGRect {
        CGRect(origin: offset, size: size)
    }

    var selectionBounds: CGRect {
        CGRect(origin: .zero, size: size)
            .insetBy(dx: -SelectionProxy.radius, dy: -SelectionProxy.radius)
    }

    var selectionFrame: CGRect {
        CGRect(origin: offset, size: size)
            .insetBy(dx: -SelectionProxy.radius, dy: -SelectionProxy.radius)
    }

    var position: CGPoint {
        graphicFrame.origin
    }

    var selectionPosition: CGPoint {
        selectionFrame.origin
    }

    func rect(direction: Direction) -> CGRect {
        rect(direction: direction, in: graphicBounds)
    }

    func rect(direction: Direction, in bounds: CGRect) -> CGRect {

        let size = CGSize(width: SelectionProxy.radius * 2.0, height: SelectionProxy.radius * 2.0)
        let origin: CGPoint

        switch direction {
            case .top:
                origin = CGPoint(x: bounds.midX - SelectionProxy.radius, y: bounds.minY - SelectionProxy.radius)
            case .topLeft:
                origin = CGPoint(x: bounds.minX - SelectionProxy.radius, y: bounds.minY - SelectionProxy.radius)
            case .left:
                origin = CGPoint(x: bounds.minX - SelectionProxy.radius, y: bounds.midY - SelectionProxy.radius)
            case .bottomLeft:
                origin = CGPoint(x: bounds.minX - SelectionProxy.radius, y: bounds.maxY - SelectionProxy.radius)
            case .bottom:
                origin = CGPoint(x: bounds.midX - SelectionProxy.radius, y: bounds.maxY - SelectionProxy.radius)
            case .bottomRight:
                origin = CGPoint(x: bounds.maxX - SelectionProxy.radius, y: bounds.maxY - SelectionProxy.radius)
            case .right:
                origin = CGPoint(x: bounds.maxX - SelectionProxy.radius, y: bounds.midY - SelectionProxy.radius)
            case .topRight:
                origin = CGPoint(x: bounds.maxX - SelectionProxy.radius, y: bounds.minY - SelectionProxy.radius)
        }

        return CGRect(origin: origin, size: size)
    }

    func hitTest(_ location: CGPoint) -> Direction? {
        for direction in Direction.allCases {
            let rect = rect(direction: direction)
                .insetBy(dx: -SelectionProxy.extendedRadius,
                         dy: -SelectionProxy.extendedRadius)

            if rect.contains(location) {
                return direction
            }
        }

        return nil
    }
}

struct SelectionView: View {

    var proxy: SelectionProxy

    init(proxy: SelectionProxy) {
        self.proxy = proxy
    }

    var body: some View {
        ZStack(alignment: .center) {
            SelectionBorder()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(Color.blue)

            SelectionControls(proxy: proxy)
                .fill(Color.white)

            SelectionControls(proxy: proxy)
                .stroke(Color.blue)
        }
    }
}

struct SelectionBorder: Shape {

    private struct Segment {

        /// Point to connect with previous segment
        var from: CGPoint

        /// Point to connect with next segment
        var to: CGPoint
    }

    func path(in rect: CGRect) -> Path {

        let diameter = SelectionProxy.radius * 2.0

        let segments: [Segment] = [
            // Top-Left to Top-Right
            Segment(from: CGPoint(x: rect.minX + diameter, y: rect.minY + SelectionProxy.radius),
                    to: CGPoint(x: rect.midX - SelectionProxy.radius, y: rect.minY + SelectionProxy.radius)),

            Segment(from: CGPoint(x: rect.midX + SelectionProxy.radius, y: rect.minY + SelectionProxy.radius),
                    to: CGPoint(x: rect.maxX - diameter, y: rect.minY + SelectionProxy.radius)),

            // Top-Right to Bottom-Left
            Segment(from: CGPoint(x: rect.maxX - SelectionProxy.radius, y: rect.minY + diameter),
                    to: CGPoint(x: rect.maxX - SelectionProxy.radius, y: rect.midY - SelectionProxy.radius)),

            Segment(from: CGPoint(x: rect.maxX - SelectionProxy.radius, y: rect.midY + SelectionProxy.radius),
                    to: CGPoint(x: rect.maxX - SelectionProxy.radius, y: rect.maxY - diameter)),

            // Bottom-Right to Bottom-Left
            Segment(from: CGPoint(x: rect.maxX - diameter, y: rect.maxY - SelectionProxy.radius),
                    to: CGPoint(x: rect.midX + SelectionProxy.radius, y: rect.maxY - SelectionProxy.radius)),

            Segment(from: CGPoint(x: rect.midX - SelectionProxy.radius, y: rect.maxY - SelectionProxy.radius),
                    to: CGPoint(x: rect.minX + diameter, y: rect.maxY - SelectionProxy.radius)),

            // Bottom-Left to Top-Left
            Segment(from: CGPoint(x: rect.minX + SelectionProxy.radius, y: rect.maxY - diameter),
                    to: CGPoint(x: rect.minX + SelectionProxy.radius, y: rect.midY + SelectionProxy.radius)),

            Segment(from: CGPoint(x: rect.minX + SelectionProxy.radius, y: rect.midY - SelectionProxy.radius),
                    to: CGPoint(x: rect.minX + SelectionProxy.radius, y: rect.minY + diameter))
        ]

        var path = Path()

        for segment in segments {
            path.move(to: segment.from)
            path.addLine(to: segment.to)
        }

        return path
    }
}

struct SelectionControls: Shape {

    var proxy: SelectionProxy

    func path(in rect: CGRect) -> Path {

        var path = Path()

        let controls = Direction.allCases.map {
            proxy.rect(direction: $0,
                       in: rect.insetBy(dx: SelectionProxy.radius, dy: SelectionProxy.radius))
        }

        for control in controls {
            path.addEllipse(in: control)
        }

        return path
    }
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let graphic = Graphic(id: "",
                              name: "",
                              content: .ellipse,
                              children: nil,
                              fill: .yellow,
                              offset: CGPoint(x: 100.0, y: 100.0),
                              size: CGSize(width: 100.0, height: 150.0))

        let proxy = SelectionProxy(graphic: graphic)

        ZStack(alignment: .topLeading) {
            GraphicShapeView(graphic: graphic)
                .frame(width: proxy.graphicBounds.width,
                       height: proxy.graphicBounds.height)
                .position(x: proxy.position.x + proxy.graphicBounds.width * 0.5,
                          y: proxy.position.y + proxy.graphicBounds.height * 0.5)

            SelectionView(proxy: proxy)
                .frame(width: proxy.selectionBounds.width,
                       height: proxy.selectionBounds.height)
                .position(x: proxy.selectionPosition.x + proxy.selectionFrame.width * 0.5,
                          y: proxy.selectionPosition.y + proxy.selectionFrame.height * 0.5)
        }
        .frame(width: 320.0, height: 480.0)
        .offset(x: 0.0, y: 0.0)
        .background(Color.gray)

    }
}
