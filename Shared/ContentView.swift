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

    @State private var isLibraryPresented = false

    var body: some View {
        #if os(macOS)
        HSplitView {
            NavigatorView(graphics: document.graphics, selection: $selection)
                .frame(width: 200.0)

            HSplitView {
                CanvasView(graphics: $document.graphics, selection: $selection)
                    .layoutPriority(1.0)
                InspectorView(graphics: $document.graphics, selection: $selection)
                    .frame(minWidth: 200.0, maxWidth: 320.0)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    isLibraryPresented.toggle()
                } label: {
                    Image(systemName: "square.on.circle")
                }
                .popover(isPresented: $isLibraryPresented) {
                    LibraryView(document: $document)
                }
            }
        }
        #else
        CanvasView(graphics: $document.graphics, selection: $selection)
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        isLibraryPresented.toggle()
                    } label: {
                        Image(systemName: "square.on.circle")
                    }
                    .popover(isPresented: $isLibraryPresented) {
                        LibraryView(document: $document)
                    }
                }
            }
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(ShapeEditDocument()))
    }
}
