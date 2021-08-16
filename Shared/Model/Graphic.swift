//
//  Graphic.swift
//  ShapeEdit
//
//  Created by Dmytro Anokhin on 22/07/2021.
//

import SwiftUI
import Foundation


struct Graphic: TreeNode, Hashable, Codable, Identifiable {

    var id: String

    var name: String

    var content: Content

    var children: [Graphic]?

    var fill: PaletteColor?

    var stroke: Graphic.Stroke?

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

    enum Content: Equatable, Codable, CaseIterable {

        case rect

        case triangle

        case ellipse
    }
}

extension Graphic {

    struct Stroke: Equatable, Codable {

        var style: PaletteColor

        var lineWidth: CGFloat
    }

    enum PaletteColor: Equatable, Codable, CaseIterable, Identifiable {

        var id: Self {
            self
        }

        case red

        case blue

        case green

        case cyan

        case magenta

        case yellow

        var color: Color {
            switch self {
                case .red:
                    return Color(.displayP3, red: 235.0 / 255.0, green: 57.0 / 255.0, blue: 86.0 / 255.0, opacity: 1.0)
                case .blue:
                    return Color(.displayP3, red: 39.0 / 255.0, green: 105.0 / 255.0, blue: 185.0 / 255.0, opacity: 1.0)
                case .green:
                    return Color(.displayP3, red: 79.0 / 255.0, green: 174.0 / 255.0, blue: 92.0 / 255.0, opacity: 1.0)
                case .cyan:
                    return Color(.displayP3, red: 86.0 / 255.0, green: 194.0 / 255.0, blue: 214.0 / 255.0, opacity: 1.0)
                case .magenta:
                    return Color(.displayP3, red: 133.0 / 255.0, green: 46.0 / 255.0, blue: 233.0 / 255.0, opacity: 1.0)
                case .yellow:
                    return Color(.displayP3, red: 247.0 / 255.0, green: 241.0 / 255.0, blue: 80.0 / 255.0, opacity: 1.0)
            }
        }
    }
}
