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

            if let children = graphic.children {
                queue.append(contentsOf: children)
            }
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

extension Graphic {

    func hitTest(_ point: CGPoint) -> Graphic? {
        if let children = children, let child = children.hitTest(point) {
            return child
        }

        let rect = CGRect(origin: offset, size: size)
        return rect.contains(point) ? self : nil
    }
}

extension Sequence where Element == Graphic {

    func hitTest(_ point: CGPoint) -> Graphic? {
        for element in self.reversed() {
            if let result = element.hitTest(point) {
                return result
            }
        }

        return nil
    }
}

extension Array where Element == Graphic {

    mutating func update(_ id: String, change: (_ graphic: inout Graphic) -> Void) {
        guard let index = firstIndex(where: { $0.id == id }) else {
            var counter = count

            while counter > 0 {
                var element = removeFirst()

                if var children = element.children {
                    children.update(id, change: change)
                    element.children = children
                }

                append(element)
                counter -= 1
            }

            return
        }

        var element = self[index]
        change(&element)
        self[index] = element
    }
}