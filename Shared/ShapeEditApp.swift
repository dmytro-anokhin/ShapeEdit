//
//  ShapeEditApp.swift
//  Shared
//
//  Created by Dmytro Anokhin on 22/07/2021.
//

import SwiftUI

@main
struct ShapeEditApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ShapeEditDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
