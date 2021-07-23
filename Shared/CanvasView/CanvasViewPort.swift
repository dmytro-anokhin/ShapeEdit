//
//  CanvasViewPort.swift
//  ShapeEdit
//
//  Created by Dmytro Anokhin on 23/07/2021.
//

import SwiftUI


struct CanvasViewPort: View {

    @State var document: ShapeEditDocument

    var body: some View {
        CanvasView(graphics: $document.graphics)
            .frame(minWidth: 800.0, minHeight: 600.0, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}
