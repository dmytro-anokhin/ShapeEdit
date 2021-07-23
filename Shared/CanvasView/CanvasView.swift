//
//  CanvasView.swift
//  ShapeEdit
//
//  Created by Dmytro Anokhin on 23/07/2021.
//

import SwiftUI


struct CanvasView: View {

    @Binding var graphics: [Graphic]

    @State var canvasSize = CGSize(width: 1920.0, height: 1080.0)

    var body: some View {
        canvas
            .aspectRatio(canvasSize.width / canvasSize.height, contentMode: .fit)
    }

    @ViewBuilder var canvas: some View {
        ZStack(alignment: .topLeading) {
        }
    }
}
