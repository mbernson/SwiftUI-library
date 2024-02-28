//
//  NavigationDestination.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 28/02/2024.
//

import SwiftUI

@available(iOS 16.0, *)
private struct NavigationDestinationItem<Item: Hashable, Destination: View>: ViewModifier {
    @Binding var item: Item?
    @ViewBuilder var destination: (Item) -> Destination

    var isPresented: Bool {
        item != nil
    }

    func body(content: Content) -> some View {
        content.navigationDestination(isPresented: .constant(isPresented), destination: {
            if let item {
                destination(item)
            } else {
                EmptyView()
            }
        })
    }
}

extension View {
    /// Drop-in replacement for the view modifier with the same signature that is available on iOS 17 and higher.
    @available(iOS 16.0, *)
    func navigationDestination<Item: Hashable, Destination: View>(
        item: Binding<Optional<Item>>,
        @ViewBuilder destination: @escaping (Item) -> Destination
    ) -> some View {
        modifier(NavigationDestinationItem(item: item, destination: destination))
    }
}
