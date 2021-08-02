//
//  ContentView.swift
//  Shared
//
//  Created by Dmytro Anokhin on 22/07/2021.
//

import SwiftUI

struct ContentView: View {

    @Binding var document: ShapeEditDocument

    var body: some View {
        #if os(macOS)
        HSplitView {
            NavigatorView(graphics: document.graphics)
            CanvasView(graphics: $document.graphics)
        }
        #else
        CanvasView(graphics: $document.graphics)
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(ShapeEditDocument()))
    }
}
