//
//  Graphic.swift
//  ShapeEdit
//
//  Created by Dmytro Anokhin on 22/07/2021.
//

import CoreGraphics


struct Graphic: Hashable, Codable, Identifiable {

    var id: String

    var content: Content

    var children: [Graphic] = []

    var fill: Fill

    var offset: CGPoint = .zero
    var size: CGSize = .zero

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Graphic {

    enum Content: Equatable, Codable {

        case rect

        case triangle

        case circle
    }
}

extension Graphic {

    enum Fill: Equatable, Codable {

        case red

        case green

        case blue
    }
}
