//
//  Utilities.swift
//  ShapeEdit
//
//  Created by Dmytro Anokhin on 23/07/2021.
//

import SwiftUI


struct Triangle: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: 0.0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0.0, y: rect.maxY))
        path.closeSubpath()

        return path
    }
}

extension Graphic {

    var flatten: [Graphic] {
        var result: [Graphic] = []
        var queue: [Graphic] = [self]

        while !queue.isEmpty {
            let graphic = queue.removeFirst()
            result.append(graphic)
            queue.append(contentsOf: graphic.children)
        }

        return result
    }
}

extension Graphic.Fill {

    var color: Color {
        switch self {
            case .red:
                return Color(.displayP3, red: 1.0, green: 0.0, blue: 0.0, opacity: 1.0)
            case .green:
                return Color(.displayP3, red: 0.0, green: 1.0, blue: 0.0, opacity: 1.0)
            case .blue:
                return Color(.displayP3, red: 0.0, green: 0.0, blue: 1.0, opacity: 1.0)
            case .cyan:
                return Color(.displayP3, red: 0.0, green: 1.0, blue: 1.0, opacity: 1.0)
            case .magenta:
                return Color(.displayP3, red: 1.0, green: 0.0, blue: 1.0, opacity: 1.0)
            case .yellow:
                return Color(.displayP3, red: 1.0, green: 1.0, blue: 0.0, opacity: 1.0)
        }
    }
}
