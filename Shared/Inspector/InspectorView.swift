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
                ColorRowView(title: "Fill Color:", selected: $state.fill)
                ColorRowView(title: "Stroke Color:", selected: $state.strokeColor)
            }
            .padding(.all)
        }
        .onChange(of: selection) { newValue in
            let selected = graphics.flatten.filter { graphic in
                selection.contains(graphic.id)
            }

            if selected.count == 1 {
                let graphic = selected.first!
                state.update(graphic)
            } else {
                state.update(nil)
            }
        }
        .onReceive(state.objectWillChange) {
            guard !state.isUpdating else {
                return
            }

            updateBindings()
        }
    }

    @StateObject private var state = InspectorModel()

    private func updateBindings() {
        for id in selection {
            graphics.update(id) { graphic in
                graphic.fill = state.fill
                graphic.stroke = state.stroke
            }
        }
    }
}

final class InspectorModel: ObservableObject {

    @Published var fill: Graphic.PaletteColor?

    @Published var strokeColor: Graphic.PaletteColor?

    @Published var strokeLineWidth: CGFloat = 1.0

    var stroke: Graphic.Stroke? {
        get {
            if let strokeColor = strokeColor {
                return .init(style: strokeColor, lineWidth: strokeLineWidth)
            } else {
                return nil
            }
        }

        set {
            strokeColor = newValue?.style
            strokeLineWidth = newValue?.lineWidth ?? 1.0
        }
    }

    init() {
        fill = nil
        strokeColor = nil
    }

    func update(_ graphic: Graphic?) {
        isUpdating = true

        fill = graphic?.fill
        stroke = graphic?.stroke

        DispatchQueue.main.async {
            self.isUpdating = false
        }
    }

    /// Calling `update(_:)` method sets this flag and resets asynchronously on the main queue after publishing update. This prevents client code from setting style on a same graphic object. And in particular, resetting styles when multiple graphic object selected.
    var isUpdating: Bool = false
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


//struct InspectorView_Previews: PreviewProvider {
//    static var previews: some View {
//        InspectorView()
//    }
//}
