//
//  SelectionView.swift
//  SelectionView
//
//  Created by Dmytro Anokhin on 03/08/2021.
//

import SwiftUI


struct SelectionProxy: Hashable, Identifiable {

    var graphic: Graphic

    var radius: CGFloat = 5.0

    var translation: CGSize = .zero

    var graphicBounds: CGRect {
        CGRect(origin: .zero, size: graphic.size)
    }

    var graphicFrame: CGRect {
        CGRect(origin: graphic.offset, size: graphic.size)
    }

    var selectionBounds: CGRect {
        CGRect(origin: .zero, size: graphic.size)
            .insetBy(dx: -radius, dy: -radius)
    }

    var selectionFrame: CGRect {
        CGRect(origin: graphic.offset, size: graphic.size)
            .insetBy(dx: -radius, dy: -radius)
    }

    var position: CGPoint {
        CGPoint(x: graphicFrame.minX + graphicBounds.width * 0.5,
                y: graphicFrame.minY + graphicBounds.height * 0.5)
    }

    var selectionPosition: CGPoint {
        CGPoint(x: selectionFrame.minX + selectionFrame.width * 0.5,
                y: selectionFrame.minY + selectionFrame.height * 0.5)
    }

    func rect(direction: Direction) -> CGRect {

        let size = CGSize(width: radius * 2.0, height: radius * 2.0)
        let origin: CGPoint

        switch direction {
            case .top:
                origin = CGPoint(x: graphicBounds.midX - radius, y: graphicBounds.minY - radius)
            case .topLeft:
                origin = CGPoint(x: graphicBounds.minX - radius, y: graphicBounds.minY - radius)
            case .left:
                origin = CGPoint(x: graphicBounds.minX - radius, y: graphicBounds.midY - radius)
            case .bottomLeft:
                origin = CGPoint(x: graphicBounds.minX - radius, y: graphicBounds.maxY - radius)
            case .bottom:
                origin = CGPoint(x: graphicBounds.midX - radius, y: graphicBounds.maxY - radius)
            case .bottomRight:
                origin = CGPoint(x: graphicBounds.maxX - radius, y: graphicBounds.maxY - radius)
            case .right:
                origin = CGPoint(x: graphicBounds.maxX - radius, y: graphicBounds.midY - radius)
            case .topRight:
                origin = CGPoint(x: graphicBounds.maxX - radius, y: graphicBounds.minY - radius)
        }

        return CGRect(origin: origin, size: size)
    }

    func hitTest(_ location: CGPoint) -> Direction? {
        nil
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(graphic)
    }

    // MARK: - Identifiable

    var id: String {
        graphic.id
    }
}

struct SelectionView: View {

    var proxy: SelectionProxy

    init(proxy: SelectionProxy) {
        self.proxy = proxy
    }

    var body: some View {
        ZStack(alignment: .center) {
            SelectionBorder(radius: proxy.radius)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(Color.blue)

            SelectionControls(controls: Direction.allCases.map { proxy.rect(direction: $0) })
                .fill(Color.white)
                .offset(x: proxy.radius, y: proxy.radius)

            SelectionControls(controls: Direction.allCases.map { proxy.rect(direction: $0) })
                .stroke(Color.blue)
                .offset(x: proxy.radius, y: proxy.radius)
        }
    }
}

struct SelectionBorder: Shape {

    var radius: CGFloat

    private struct Segment {

        /// Point to connect with previous segment
        var from: CGPoint

        /// Point to connect with next segment
        var to: CGPoint
    }

    func path(in rect: CGRect) -> Path {

        let diameter = radius * 2.0

        let segments: [Segment] = [
            // Top-Left to Top-Right
            Segment(from: CGPoint(x: rect.minX + diameter, y: rect.minY + radius),
                    to: CGPoint(x: rect.midX - radius, y: rect.minY + radius)),

            Segment(from: CGPoint(x: rect.midX + radius, y: rect.minY + radius),
                    to: CGPoint(x: rect.maxX - diameter, y: rect.minY + radius)),

            // Top-Right to Bottom-Left
            Segment(from: CGPoint(x: rect.maxX - radius, y: rect.minY + diameter),
                    to: CGPoint(x: rect.maxX - radius, y: rect.midY - radius)),

            Segment(from: CGPoint(x: rect.maxX - radius, y: rect.midY + radius),
                    to: CGPoint(x: rect.maxX - radius, y: rect.maxY - diameter)),

            // Bottom-Right to Bottom-Left
            Segment(from: CGPoint(x: rect.maxX - diameter, y: rect.maxY - radius),
                    to: CGPoint(x: rect.midX + radius, y: rect.maxY - radius)),

            Segment(from: CGPoint(x: rect.midX - radius, y: rect.maxY - radius),
                    to: CGPoint(x: rect.minX + diameter, y: rect.maxY - radius)),

            // Bottom-Left to Top-Left
            Segment(from: CGPoint(x: rect.minX + radius, y: rect.maxY - diameter),
                    to: CGPoint(x: rect.minX + radius, y: rect.midY + radius)),

            Segment(from: CGPoint(x: rect.minX + radius, y: rect.midY - radius),
                    to: CGPoint(x: rect.minX + radius, y: rect.minY + diameter))
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

    var controls: [CGRect] = []

    func path(in rect: CGRect) -> Path {

        var path = Path()

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
                .position(x: proxy.position.x,
                          y: proxy.position.y)

            SelectionView(proxy: proxy)
                .frame(width: proxy.selectionBounds.width,
                       height: proxy.selectionBounds.height)
                .position(x: proxy.selectionPosition.x,
                          y: proxy.selectionPosition.y)
        }
        .frame(width: 320.0, height: 480.0)
        .offset(x: 0.0, y: 0.0)
        .background(Color.gray)

    }
}
