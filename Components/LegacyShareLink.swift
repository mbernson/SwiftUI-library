//
//  LegacyShareLink.swift
//
//  Created by Mathijs Bernson on 10/02/2023.
//

import SwiftUI
import UIKit

/// A fallback for the SwiftUI `ShareLink` component that is compatible with iOS 15.
@available(iOS, deprecated: 15.0, message: "Use ShareLink instead")
struct LegacyShareLink<Label: View>: View {
    @ViewBuilder var label: () -> Label
    let activityItems: [Any]
    @State var isPresented = false
    let completion: () -> Void

    // The `ShareLink` component has many different overloads. I haven't recreated them all.
    // Just add them as needed.

    init(_ title: LocalizedStringKey, item: Any, message: String? = nil, completion: @escaping () -> Void = {}) where Label == Text {
        self.label = { Text(title) }
        if let message {
            self.activityItems = [message, item]
        } else {
            self.activityItems = [item]
        }
        self.completion = completion
    }

    init(item: Any, @ViewBuilder label: @escaping () -> Label, message: String? = nil, completion: @escaping () -> Void = {}) {
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
            let activityController = makeActivityController(presentingViewController: viewController)
            viewController.present(activityController, animated: true)
        }
    }

    func makeActivityController(presentingViewController: UIViewController) -> UIActivityViewController {
        let copyLinkActivity = CopyLinkActivity()
        let activityController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: [copyLinkActivity]
        )
        activityController.excludedActivityTypes = [
            .addToReadingList,
            .openInIBooks,
            .print,
            .assignToContact,
            .markupAsPDF,
        ]

        let hasCopyLink = copyLinkActivity.canPerform(withActivityItems: activityItems)
        if hasCopyLink {
            activityController.excludedActivityTypes?.append(.copyToPasteboard)
        }

        activityController.popoverPresentationController?.sourceView = presentingViewController.view
        activityController.completionWithItemsHandler = { activityType, completed, returnedItems, error in
            isPresented = false
            completion(completed)
        }
        return activityController
    }
}

private typealias LegacyShareSheetAnchorController = UIViewController

private class CopyLinkActivity: UIActivity {
    private var url: URL?

    override var activityType: UIActivity.ActivityType? {
        return UIActivity.ActivityType(rawValue: "\(Bundle.main.bundleIdentifier!).CopyLink")
    }

    override var activityTitle: String? {
        return NSLocalizedString("Copy link", comment: "Share sheet button")
    }

    override var activityImage: UIImage? {
        return UIImage(systemName: "doc.on.doc")
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for activityItem in activityItems {
            if activityItem as? URL != nil {
                return true
            }
        }

        return false
    }

    override func prepare(withActivityItems activityItems: [Any]) {
        for activityItem in activityItems {
            if let url = activityItem as? URL {
                self.url = url
            }
        }
    }

    override func perform() {
        UIPasteboard.general.string = url?.absoluteString
        activityDidFinish(true)
    }
}

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
