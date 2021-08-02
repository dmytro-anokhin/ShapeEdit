//
//  ShapeEditDocument.swift
//  Shared
//
//  Created by Dmytro Anokhin on 22/07/2021.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {

    static let shapeEditDocument = UTType(exportedAs: "com.example.ShapeEdit.shapes")
}

struct ShapeEditDocument: FileDocument, Codable {

    var graphics: [Graphic]

    init(graphics: [Graphic] = Graphic.test) {
        self.graphics = graphics
    }

    static var readableContentTypes: [UTType] { [.shapeEditDocument] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }

        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(self)
        return .init(regularFileWithContents: data)
    }
}
