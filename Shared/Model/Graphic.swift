//
//  Graphic.swift
//  ShapeEdit
//
//  Created by Dmytro Anokhin on 22/07/2021.
//

import CoreGraphics
import Foundation


struct Graphic: Hashable, Codable, Identifiable {

    var id: String

    var name: String

    var content: Content

    var children: [Graphic]?

    var fill: Fill?

    var stroke: Stroke?

    var offset: CGPoint = .zero
    var size: CGSize = .zero

    var frame: CGRect {
        CGRect(origin: offset, size: size)
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Graphic {

    enum Content: Equatable, Codable {

        case rect

        case triangle

        case ellipse
    }
}

extension Graphic {

    enum Fill: Equatable, Codable {

        case red

        case green

        case blue

        case cyan

        case magenta

        case yellow
    }

    enum Stroke: Equatable, Codable {

        case red

        case green

        case blue

        case cyan

        case magenta

        case yellow
    }
}


extension Graphic {

    static var test: [Graphic] {
        [
            Graphic(id: UUID().uuidString,
                    name: "Rectangle",
                    content: .rect,
                    children: [
                        Graphic(id: UUID().uuidString,
                                name: "Rectangle",
                                content: .rect,
                                children: nil,
                                fill: .red,
                                stroke: nil,
                                offset: CGPoint(x: 425.0, y: 125.0),
                                size: CGSize(width: 50.0, height: 50.0)),
                        Graphic(id: UUID().uuidString,
                                name: "Triangle",
                                content: .triangle,
                                children: nil,
                                fill: .green,
                                stroke: nil,
                                offset: CGPoint(x: 450.0, y: 110.0),
                                size: CGSize(width: 50.0, height: 50.0)),
                        Graphic(id: UUID().uuidString,
                                name: "Ellipse",
                                content: .ellipse,
                                children: nil,
                                fill: .blue,
                                stroke: nil,
                                offset: CGPoint(x: 400.0, y: 100.0),
                                size: CGSize(width: 50.0, height: 50.0))
                    ],
                    fill: .cyan,
                    offset: CGPoint(x: 400.0, y: 100.0),
                    size: CGSize(width: 200.0, height: 200.0)),
            Graphic(id: UUID().uuidString,
                    name: "Triangle",
                    content: .triangle,
                    children: nil,
                    fill: .magenta,
                    stroke: nil,
                    offset: CGPoint(x: 550.0, y: 200.0),
                    size: CGSize(width: 300.0, height: 200.0)),
            Graphic(id: UUID().uuidString,
                    name: "Ellipse",
                    content: .ellipse,
                    children: nil,
                    fill: .yellow,
                    stroke: nil,
                    offset: CGPoint(x: 300.0, y: 300.0),
                    size: CGSize(width: 250.0, height: 250.0))
        ]
    }
}
