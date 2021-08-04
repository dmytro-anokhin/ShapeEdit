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

    var translation: CGSize

    var direction: Direction?
}
