//
//  ContentView.swift
//  Shared
//
//  Created by Dmytro Anokhin on 22/07/2021.
//

import SwiftUI

struct ContentView: View {

    @Binding var document: ShapeEditDocument

    @State var selection: Set<String> = []

    var body: some View {
        #if os(macOS)
        HSplitView {
            NavigatorView(graphics: document.graphics, selection: $selection)
                .frame(width: 200.0)
            CanvasView(graphics: $document.graphics, selection: $selection)
        }
        #else
        CanvasView(graphics: $document.graphics, selection: $selection)
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(ShapeEditDocument()))
    }
}
