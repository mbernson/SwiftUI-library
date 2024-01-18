//
//  InAppBrowserLink.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 18/01/2024.
//

import SwiftUI
import UIKit
import SafariServices

/// A component that acts similar to `ShareLink`, opening a URL in an in-app browser (`SFSafariViewController`).
struct InAppBrowserLink<Label: View>: View {
    @ViewBuilder var label: () -> Label
    let url: URL
    @State private var isPresented = false

    init(_ title: LocalizedStringKey, url: URL) where Label == Text {
        self.label = { Text(title) }
        self.url = url
    }

    init(url: URL, @ViewBuilder label: @escaping () -> Label) {
        self.label = label
        self.url = url
    }

    var body: some View {
        Button(action: {
            isPresented = true
        }, label: label)
        // We set an invisible viewcontroller representable as the background of the button,
        // so that it can serve as the presentation anchor for the `SFSafariViewController`.
        .background(InAppBrowserLinkAnchor(
            url: url,
            barCollapsingEnabled: true,
            isPresented: $isPresented
        ))
    }
}

private struct InAppBrowserLinkAnchor: UIViewControllerRepresentable {
    let url: URL
    let barCollapsingEnabled: Bool
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> InAppBrowserLinkAnchorController {
        InAppBrowserLinkAnchorController()
    }

    func updateUIViewController(_ viewController: UIViewController, context: Context) {
        if isPresented, viewController.presentedViewController == nil {
            let safariController = SFSafariViewController(url: url)
            safariController.modalPresentationStyle = .formSheet
            safariController.delegate = context.coordinator
            viewController.present(safariController, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented)
    }

    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        @Binding var isPresented: Bool

        init(isPresented: Binding<Bool>) {
            self._isPresented = isPresented
            super.init()
        }

        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            isPresented = false
        }
    }
}

private typealias InAppBrowserLinkAnchorController = UIViewController

#Preview {
    InAppBrowserLink("Tap me!", url: URL(string: "https://q42.com")!)
}
