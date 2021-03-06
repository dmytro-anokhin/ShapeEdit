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

    // MARK: - Update

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

    // MARK: - Remove

    /// Remove the node from the tree
    ///
    /// - Parameters:
    ///     - node: The node to remove.
    ///
    /// This is recursive operation in O(n) time.
    mutating func remove(_ node: Element) {
        remove(node.id)
    }

    /// Remove the node from the tree
    ///
    /// - Parameters:
    ///     - id: The id of the node to remove.
    ///
    /// This is recursive operation in O(n) time.
    mutating func remove(_ id: Element.ID) {
        _remove(id)
    }

    /// Helper for `remove` that returns `true` if the node that matches given id was removed.
    @discardableResult
    private mutating func _remove(_ id: Element.ID) -> Bool {
        var indexToRemove: Int?

        for index in 0..<count {
            var element = self[index]

            if element.id == id {
                indexToRemove = index
            } else if var children = element.children, children._remove(id) {
                element.children = children
                self[index] = element
                return true
            }
        }

        guard let indexToRemove = indexToRemove else {
            return false
        }

        remove(at: indexToRemove)
        return true
    }

    // MARK: -

    func recursiveFilter(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element] {
        try filter { element in
            if try isIncluded(element) {
                return true
            }

            if let filteredChildren = try element.children?.recursiveFilter(isIncluded) {
                return !filteredChildren.isEmpty
            }

            return false
        }
    }
//
//    /// Flatten tree in an array
//    func flatten() -> [Element] {
//        var result: [Element] = []
//        var queue: [Element] = self
//
//        while !queue.isEmpty {
//            let element = queue.removeFirst()
//            result.append(element)
//
//            if let children = element.children {
//                queue.append(contentsOf: children)
//            }
//        }
//
//        return result
//    }
}
