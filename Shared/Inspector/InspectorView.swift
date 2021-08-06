//
//  InspectorView.swift
//  InspectorView
//
//  Created by Dmytro Anokhin on 06/08/2021.
//

import SwiftUI

struct InspectorView: View {

    @Binding var graphics: [Graphic]

    @Binding var selection: Set<String>

    var body: some View {
        ScrollView {
            Form {
                VStack(alignment: .leading) {
                    Text("Fill:")
                    ColorRowView(selected: $fillColor)
                }

                VStack(alignment: .leading) {
                    Text("Stroke:")
                    ColorRowView(selected: $strokeColor)
                }
            }
            .padding(.all)
        }
        .onChange(of: selection) { newValue in
            let selected = graphics.flatten.filter { graphic in
                selection.contains(graphic.id)
            }

            if selected.count == 1 {
                let graphic = selected.first!
                fillColor = graphic.fill
                strokeColor = graphic.stroke?.style
                strokeLineWidth = graphic.stroke?.lineWidth
            } else {
                fillColor = nil
                strokeColor = nil
                strokeLineWidth = nil
            }
        }
        .onChange(of: fillColor) { newValue in
            updateBindings()
        }
        .onChange(of: strokeColor) { newValue in
            updateBindings()
        }
        .onChange(of: strokeLineWidth) { newValue in
            updateBindings()
        }
    }

    @State private var fillColor: Graphic.PaletteColor?

    @State private var strokeColor: Graphic.PaletteColor?

    @State private var strokeLineWidth: CGFloat? = 1.0

    private func updateBindings() {
        for id in selection {
            graphics.update(id) { graphic in
                graphic.fill = fillColor

                if let strokeColor = strokeColor, let lineWidth = strokeLineWidth {
                    graphic.stroke = .init(style: strokeColor, lineWidth: lineWidth)
                } else {
                    graphic.stroke = nil
                }
            }
        }
    }
}


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

    @Binding var selected: Graphic.PaletteColor?

    var body: some View {
        let columns = [
            GridItem(.adaptive(minimum: ColorRowView.itemSize.width, maximum: ColorRowView.itemSize.width))
        ]

        let items = Graphic.PaletteColor.allCases.map { Item(paletteColor: $0) } + [ Item(paletteColor: nil) ]

        return LazyVGrid(columns: columns) {
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


//struct InspectorView_Previews: PreviewProvider {
//    static var previews: some View {
//        InspectorView()
//    }
//}
