//
//  Graphic.swift
//  ShapeEdit
//
//  Created by Dmytro Anokhin on 22/07/2021.
//

import CoreGraphics


struct Graphic: Hashable, Codable, Identifiable {

    var id: String

    var children: [Graphic] = []

    var offset: CGPoint = .zero
    var size: CGSize = .zero

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
