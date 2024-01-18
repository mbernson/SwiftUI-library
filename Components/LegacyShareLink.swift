//
//  LegacyShareLink.swift
//
//  Created by Mathijs Bernson on 10/02/2023.
//

import SwiftUI
import UIKit

/// A fallback for the SwiftUI `ShareLink` component that is compatible with iOS 15.
struct LegacyShareLink<Label: View>: View {
    @ViewBuilder var label: () -> Label
    let activityItems: [Any]
    @State var isPresented = false
    let completion: () -> Void

    // The `ShareLink` component has many different overloads. I haven't recreated them all.
    // Just add them as needed.

    init(_ title: LocalizedStringKey, item: Any, message: String? = nil, completion: @escaping () -> Void) where Label == Text {
        self.label = { Text(title) }
        if let message {
            self.activityItems = [message, item]
        } else {
            self.activityItems = [item]
        }
        self.completion = completion
    }

    init(item: Any, label: @escaping () -> Label, message: String? = nil, completion: @escaping () -> Void) {
        self.label = label
        if let message {
            self.activityItems = [message, item]
        } else {
            self.activityItems = [item]
        }
        self.completion = completion
    }

    var body: some View {
        Button(action: {
            isPresented = true
        }, label: label)
        // We set an invisible viewcontroller representable as the background of the button,
        // so that it can serve as the presentation anchor for the `UIActivityViewController`.
        .background(LegacyShareSheetAnchor(activityItems: activityItems, isPresented: $isPresented) { completed in
            completion()
        })
    }
}

private struct LegacyShareSheetAnchor: UIViewControllerRepresentable {
    let activityItems: [Any]
    @Binding var isPresented: Bool
    let completion: (Bool) -> Void

    func makeUIViewController(context: Context) -> LegacyShareSheetAnchorController {
        LegacyShareSheetAnchorController()
    }

    func updateUIViewController(_ viewController: LegacyShareSheetAnchorController, context: Context) {
        if isPresented, viewController.presentedViewController == nil {
            let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = viewController.view
            activityController.completionWithItemsHandler = { activityType, completed, returnedItems, error in
                isPresented = false
                completion(completed)
            }
            viewController.present(activityController, animated: true)
        }
    }
}

private typealias LegacyShareSheetAnchorController = UIViewController

#Preview("Legacy share link") {
    LegacyShareLink("Deel link", item: URL(string: "https://q42.nl/")!, message: "Q42 website", completion: {
        print("Share completed")
    })
}

#Preview("Legacy share link with custom label") {
    LegacyShareLink(item: URL(string: "https://q42.nl/")!, label: {
        Label("Deel link", image: "share")
    }, completion: {
        print("Share completed")
    })
}
