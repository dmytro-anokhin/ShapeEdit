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


//struct InspectorView_Previews: PreviewProvider {
//    static var previews: some View {
//        InspectorView()
//    }
//}
