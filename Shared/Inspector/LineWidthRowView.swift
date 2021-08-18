//
//  LineWidthRowView.swift
//  LineWidthRowView
//
//  Created by Dmytro Anokhin on 18/08/2021.
//

import SwiftUI

struct LineWidthRowView: View {

    static let formatter: Formatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1

        return formatter
    }()

    var title: String

    @Binding var value: CGFloat

    var step: CGFloat = 0.5
    var range: ClosedRange<CGFloat> = 0.0...10.0

    var body: some View {
        let formattedValue = LineWidthRowView.formatter.string(for: value)!

        Stepper {
            Text("\(title) \(formattedValue)")
        } onIncrement: {
            value = min(value + step, range.upperBound)
        } onDecrement: {
            value = min(value + step, range.lowerBound)
        }
    }
}

struct LineWidthRowView_Previews: PreviewProvider {
    static var previews: some View {
        LineWidthRowView(title: "Line Width:", value: .constant(1.0))
    }
}
