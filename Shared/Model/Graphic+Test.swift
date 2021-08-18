//
//  Graphic+Test.swift
//  Graphic+Test
//
//  Created by Dmytro Anokhin on 08/08/2021.
//

import Foundation
import CoreGraphics

extension Graphic {

    static var smallSet: [Graphic] {
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

    static func generateSample(length: Int, children childrenPattern: [Int]) -> [Graphic] {
        var result: [Graphic] = []

        let minSize = CGSize(width: 100.0, height: 100.0)
        let maxSize = CGSize(width: 400.0, height: 400.0)

        let minOffset = CGPoint(x: 0.0, y: 0.0)
        let maxOffset = CGPoint(x: 1920.0, y: 1080.0)

        for _ in 0..<length {
            let children: [Graphic]?

            if let first = childrenPattern.first {
                children = generateSample(length: Int.random(in: 1...first), children: Array(childrenPattern.dropFirst()))
            } else {
                children = nil
            }

            let uuidString = UUID().uuidString
            let content = Graphic.Content.allCases.randomElement()!

            var size: CGSize = CGSize(width: CGFloat.random(in: minSize.width...maxSize.width),
                                      height: CGFloat.random(in: minSize.height...maxSize.height))

            switch content {
                case .ellipse:
                    size.width = size.height
                default:
                    break
            }

            var offset = CGPoint(x: CGFloat.random(in: minOffset.x...maxOffset.x),
                                 y: CGFloat.random(in: minOffset.y...maxOffset.y))

            offset.x = min(offset.x, maxOffset.x - size.width)
            offset.y = min(offset.y, maxOffset.y - size.height)

            let stroke: Graphic.Stroke?

            if Int.random(in: 0..<4) == 0 {
                let color = Graphic.PaletteColor.allCases.randomElement()!
                let lineWidth = CGFloat.random(in: 1.0...10.0)
                stroke = Graphic.Stroke(style: color, lineWidth: lineWidth)
            } else {
                stroke = nil
            }

            let graphic = Graphic(id: uuidString,
                                  name: uuidString,
                                  content: content,
                                  children: children,
                                  fill: Graphic.PaletteColor.allCases.randomElement()!,
                                  stroke: stroke,
                                  offset: offset,
                                  size: size)
            result.append(graphic)
        }

        return result
    }
}
