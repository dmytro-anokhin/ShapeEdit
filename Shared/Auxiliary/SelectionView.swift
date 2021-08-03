//
//  SelectionView.swift
//  SelectionView
//
//  Created by Dmytro Anokhin on 03/08/2021.
//

import SwiftUI

struct SelectionView<Content: View>: View {

    var radius: CGFloat = 5.0

    var content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .overlay(
                GeometryReader { geometry in
                    ZStack {
                        SelectionBorder(radius: radius)
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundColor(Color.blue)
                        SelectionDots(radius: radius)
                            .fill(Color.blue)
                    }
                    .frame(width: geometry.size.width + radius * 2.0,
                           height: geometry.size.height + radius * 2.0)
                }.offset(x: -radius, y: -radius))
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

struct SelectionDots: Shape {

    var radius: CGFloat

    func path(in rect: CGRect) -> Path {

        let diameter = radius * 2.0

        let dots: [CGPoint] = [
            // Top-left
            CGPoint(x: rect.minX, y: rect.minY),
            // Top-middle
            CGPoint(x: rect.midX - radius, y: rect.minY),
            // Top-right
            CGPoint(x: rect.maxX - diameter, y: rect.minY),
            // Middle-right
            CGPoint(x: rect.maxX - diameter, y: rect.midY - radius),
            // Bottom-right
            CGPoint(x: rect.maxX - diameter, y: rect.maxY - diameter),
            // Bottom-middle
            CGPoint(x: rect.midX - radius, y: rect.maxY - diameter),
            // Bottom-left
            CGPoint(x: rect.minX, y: rect.maxY - diameter),
            // Middle-left
            CGPoint(x: rect.minX, y: rect.midY - radius)
        ]

        var path = Path()

        let dotSize = CGSize(width: diameter, height: diameter)

        for dotOrigin in dots {
            let dotRect = CGRect(origin: dotOrigin, size: dotSize)
            path.addEllipse(in: dotRect)
        }

        return path
    }
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let graphic = Graphic(id: "",
                              name: "",
                              content: .circle,
                              children: nil,
                              fill: .yellow,
                              offset: .zero,
                              size: CGSize(width: 100.0, height: 100.0))

        SelectionView {
            GraphicShapeView(graphic: graphic)
                .frame(width: graphic.size.width, height: graphic.size.height)
        }
            .padding()
    }
}
