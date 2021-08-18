//
//  ColorRowView.swift
//  ColorRowView
//
//  Created by Dmytro Anokhin on 18/08/2021.
//

import SwiftUI

struct ColorRowView: View {

    #if os(macOS)
    static let itemSize = CGSize(width: 22.0, height: 22.0)
    static let selectionSize = CGSize(width: 24.0, height: 24.0)
    static let cornerRadius = 5.0
    #else
    static let itemSize = CGSize(width: 42.0, height: 42.0)
    static let selectionSize = CGSize(width: 44.0, height: 44.0)
    static let cornerRadius = 10.0
    #endif

    struct Item: Identifiable {

        var id: String {
            String(describing: paletteColor)
        }

        var paletteColor: Graphic.PaletteColor?
    }

    var title: String

    @Binding var selected: Graphic.PaletteColor?

    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: ColorRowView.itemSize.width, maximum: ColorRowView.itemSize.width))
        ]

        let items = Graphic.PaletteColor.allCases.map { Item(paletteColor: $0) } + [ Item(paletteColor: nil) ]

        VStack(alignment: .leading) {
            Text(title)
            LazyVGrid(columns: columns) {
                ForEach(items) { item in
                    ZStack {
                        Rectangle()
                            .fill(selected == item.paletteColor ? Color.blue : Color.clear)
                            .cornerRadius(ColorRowView.cornerRadius)
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(width: ColorRowView.selectionSize.width,
                                   height: ColorRowView.selectionSize.height)

                        if let paletteColor = item.paletteColor {
                            Circle()
                                .fill(paletteColor.color)
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(width: ColorRowView.itemSize.width,
                                       height: ColorRowView.itemSize.height)
                        } else {
                            Image(systemName: "slash.circle")
                                .resizable()
                                .font(Font.title.weight(.light))
                                .foregroundColor(.gray)
                                .aspectRatio(1.0, contentMode: .fit)
                                .frame(width: ColorRowView.itemSize.width,
                                       height: ColorRowView.itemSize.height)
                        }
                    }
                    .onTapGesture {
                        selected = item.paletteColor
                    }
                }
            }
        }
    }
}

struct ColorRowView_Previews: PreviewProvider {
    static var previews: some View {
        ColorRowView(title: "Fill", selected: .constant(.cyan))
    }
}
