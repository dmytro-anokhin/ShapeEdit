//
//  Tree.swift
//  Tree
//
//  Created by Dmytro Anokhin on 16/08/2021.
//

protocol TreeNode {

    associatedtype Child: TreeNode

    var children: [Child]? { get set }
}


extension Array where Element: TreeNode, Element: Identifiable, Element.Child == Element {

    /// Updates the node that matches the id
    ///
    /// - Parameters:
    ///     - id: The id of the node to update;
    ///     - change: The closure that encapsulate update logic for the node.
    ///
    /// This is recursive operation in O(n) time.
    mutating func update(_ id: Element.ID, change: (_ element: inout Element) -> Void) {
        _update(id, change: change)
    }

    /// Helper for `update` that returns `true` if the node that matches given id was found.
    @discardableResult
    private mutating func _update(_ id: Element.ID, change: (_ element: inout Element) -> Void) -> Bool {
        for index in 0..<count {
            var element = self[index]

            if element.id == id {
                change(&element)
                self[index] = element
                return true
            } else if var children = element.children, children._update(id, change: change) {
                element.children = children
                self[index] = element
                return true
            }
        }

        return false
    }
}
