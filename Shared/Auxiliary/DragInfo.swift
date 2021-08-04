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

    func translatedPosition(_ graphic: Graphic) -> CGPoint {
        translatedPosition(graphic.offset, graphic.size)
    }

    func translatedPosition(_ offset: CGPoint, _ size: CGSize) -> CGPoint {
        let offset = translatedOffset(offset)
        let size = translatedSize(size)

        return CGPoint(x: offset.x + size.width * 0.5, y: offset.y + size.height * 0.5)
    }

    func translatedOffset(_ offset: CGPoint) -> CGPoint {
        var offset = offset

        if let direction = direction {
            switch direction {
                case .top:
                    offset.y += translation.height

                case .topLeft:
                    offset.x += translation.width
                    offset.y += translation.height

                case .left:
                    offset.x += translation.width

                case .bottomLeft:
                    offset.x += translation.width

                case .bottom:
                    break

                case .bottomRight:
                    break

                case .right:
                    break

                case .topRight:
                    offset.y += translation.height
            }
        } else {
            offset.x += translation.width
            offset.y += translation.height
        }

        return offset
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
