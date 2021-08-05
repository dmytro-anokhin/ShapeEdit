//
//  LibraryView.swift
//  LibraryView
//
//  Created by Dmytro Anokhin on 05/08/2021.
//

import SwiftUI

struct LibraryView: View {

    struct Item: Identifiable {

        var id: Int

        var graphic: Graphic
    }

    static let graphicSize = CGSize(width: 64.0, height: 64.0)

    static let itemPadding = 20.0

    var items: [Item] = [
        Item(id: 1,
             graphic: Graphic(id: "rect",
                              name: "Rectangle",
                              content: .rect,
                              children: nil,
                              fill: .red,
                              offset: .zero,
                              size: LibraryView.graphicSize)),

        Item(id: 2,
             graphic: Graphic(id: "triangle",
                              name: "Triangle",
                              content: .triangle,
                              children: nil,
                              fill: .green,
                              offset: .zero,
                              size: LibraryView.graphicSize)),

        Item(id: 3,
             graphic: Graphic(id: "ellipse",
                              name: "Ellipse",
                              content: .ellipse,
                              children: nil,
                              fill: .blue,
                              offset: .zero,
                              size: LibraryView.graphicSize))
    ]

    @Binding var document: ShapeEditDocument

    @State var selectedItem: Int? = nil

    var body: some View {
        let minWidth = LibraryView.graphicSize.width + LibraryView.itemPadding * 2.0

        let columns = [
            GridItem(.flexible(minimum: minWidth, maximum: .infinity)),
            GridItem(.flexible(minimum: minWidth, maximum: .infinity))
        ]

        return ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(items) { item in
                    ZStack {
                        Rectangle()
                            .fill(Color(.displayP3, white: 1.0, opacity: 0.1))
                            .cornerRadius(10.0)
                            .aspectRatio(1.0, contentMode: .fit)

                        GraphicShapeView(graphic: item.graphic)
                            .aspectRatio(1.0, contentMode: .fit)
                            .padding(LibraryView.itemPadding)
                    }
                    .onTapGesture {
                        var graphic = item.graphic
                        graphic.id = UUID().uuidString
                        graphic.size = CGSize(width: 100.0, height: 100.0)
                        document.graphics.append(graphic)
                    }
                }
            }
            .padding(.all)
        }
    }
}

//struct LibraryView_Previews: PreviewProvider {
//    static var previews: some View {
//        LibraryView()
//    }
//}
