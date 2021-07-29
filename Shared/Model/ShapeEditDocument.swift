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

    init(graphics: [Graphic] = [
        Graphic(id: UUID().uuidString, content: .rect, children: [], fill: .red, offset: CGPoint(x: 100.0, y: 100.0), size: CGSize(width: 120.0, height: 80.0)),
        Graphic(id: UUID().uuidString, content: .triangle, children: [], fill: .green, offset: CGPoint(x: 200.0, y: 200.0), size: CGSize(width: 100.0, height: 100.0)),
        Graphic(id: UUID().uuidString, content: .circle, children: [], fill: .blue, offset: CGPoint(x: 300.0, y: 300.0), size: CGSize(width: 80.0, height: 80.0))
    ]) {
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
