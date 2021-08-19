//
//  GridView.swift
//  GridView
//
//  Created by Dmytro Anokhin on 30/07/2021.
//

import SwiftUI


struct GridView: View {

    var size: CGSize

    var length: CGFloat = 100.0

    var body: some View {
        ZStack {
            path(size: size, length: length * 0.25)
                .stroke(style: StrokeStyle(lineWidth: 0.5))
                .foregroundColor(Color(.displayP3, white: 0.75, opacity: 1.0))

            path(size: size, length: length)
                .stroke(style: StrokeStyle(lineWidth: 0.25))
                .foregroundColor(Color(.displayP3, white: 0.25, opacity: 1.0))
        }
        .background(Color.white)
    }

    func path(size: CGSize, length: CGFloat) -> Path {
        Path { path in
            var x = length

            while x < size.width {
                path.move(to: CGPoint(x: x, y: 0.0))
                path.addLine(to: CGPoint(x: x, y: size.height))

                x += length
            }

            var y = length

            while y < size.height {
                path.move(to: CGPoint(x: 0.0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))

                y += length
            }
        }
    }
}
