//
//  DragInfo.swift
//  DragInfo
//
//  Created by Dmytro Anokhin on 04/08/2021.
//

import CoreGraphics


/// Drag direction, counter clockwise
enum Direction: CaseIterable {

    case top

    case topLeft

    case left

    case bottomLeft

    case bottom

    case bottomRight

    case right

    case topRight
}


struct DragInfo {

    /// Translation of the drag gesture
    var translation: CGSize

    /// Direction if dragging one of selection sides
    var direction: Direction?

    func translatedFrame(_ graphic: Graphic) -> CGRect {
        translatedFrame(graphic.frame)
    }

    func translatedFrame(_ rect: CGRect) -> CGRect {
        CGRect(origin: translatedPoint(rect.origin),
               size: translatedSize(rect.size))
    }

    func translatedPoint(_ point: CGPoint) -> CGPoint {
        var point = point

        if let direction = direction {
            switch direction {
                case .top:
                    point.y += translation.height

                case .topLeft:
                    point.x += translation.width
                    point.y += translation.height

                case .left:
                    point.x += translation.width

                case .bottomLeft:
                    point.x += translation.width

                case .bottom:
                    break

                case .bottomRight:
                    break

                case .right:
                    break

                case .topRight:
                    point.y += translation.height
            }
        } else {
            point.x += translation.width
            point.y += translation.height
        }

        return point
    }

    func translatedSize(_ size: CGSize) -> CGSize {
        guard let direction = direction else {
            return size
        }

        var size = size

        switch direction {
            case .top:
                size.height -= translation.height

            case .topLeft:
                size.width -= translation.width
                size.height -= translation.height

            case .left:
                size.width -= translation.width

            case .bottomLeft:
                size.width -= translation.width
                size.height += translation.height

            case .bottom:
                size.height += translation.height

            case .bottomRight:
                size.width += translation.width
                size.height += translation.height

            case .right:
                size.width += translation.width

            case .topRight:
                size.width += translation.width
                size.height -= translation.height
        }

        return size
    }

}
