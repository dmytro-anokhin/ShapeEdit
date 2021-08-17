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

extension Graphic {

    func hitTest(_ point: CGPoint, includeChildren: Bool = true, extendBy delta: CGFloat = 0.0) -> Graphic? {
        if includeChildren, let children = children, let child = children.hitTest(point) {
            return child
        }

        return frame.insetBy(dx: -delta, dy: -delta).contains(point) ? self : nil
    }
}

extension Sequence where Element == Graphic {

    func hitTest(_ point: CGPoint, extendBy delta: CGFloat = 0.0) -> Graphic? {
        for element in self.reversed() {
            if let result = element.hitTest(point, extendBy: delta) {
                return result
            }
        }

        return nil
    }
}

// Operations on a tree of graphics. All operations are linear time O(n).
extension Array where Element == Graphic {

    /// Find first element that matches predicate
    func recursiveFirst(where predicate: (_ graphic: Graphic) -> Bool) -> Graphic? {
        var queue: [Graphic] = self

        while !queue.isEmpty {
            let graphic = queue.removeFirst()

            if predicate(graphic) {
                return graphic
            } else if let children = graphic.children {
                queue.append(contentsOf: children)
            }
        }

        return nil
    }

    /// Filter elements by predicate and returns flattened array of results
    func recursiveFilter(_ isIncluded: (Graphic) throws -> Bool) rethrows -> [Graphic] {
        var result: [Graphic] = []
        var queue: [Graphic] = self

        while !queue.isEmpty {
            let graphic = queue.removeFirst()

            if try isIncluded(graphic) {
                result.append(graphic)
            }

            if let children = graphic.children {
                queue.append(contentsOf: children)
            }
        }

        return result
    }

    /// Flatten tree in an array
    var flatten: [Graphic] {
        var result: [Graphic] = []
        var queue: [Graphic] = self

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

extension View {

    func frame(size: CGSize) -> some View {
        self.frame(width: size.width, height: size.height)
    }

    func frame(rect: CGRect) -> some View {
        self.frame(width: rect.width, height: rect.height)
            .position(x: rect.midX, y: rect.midY)
    }
}
