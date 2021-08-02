//
//  Selection.swift
//  Selection
//
//  Created by Dmytro Anokhin on 02/08/2021.
//

import SwiftUI


private struct SelectionEnvironmentKey: EnvironmentKey {

    static let defaultValue: Binding<Set<String>> = .constant([])
}

extension EnvironmentValues {

    var selection: Binding<Set<String>> {
        get { self[SelectionEnvironmentKey.self] }
        set { self[SelectionEnvironmentKey.self] = newValue }
    }
}
