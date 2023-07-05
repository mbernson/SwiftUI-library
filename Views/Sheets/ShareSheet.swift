//
//  ShareSheet.swift
//
//  Created by Mathijs Bernson on 10/02/2023.
//

import SwiftUI
import UIKit

struct ShareSheet: View {
    let activityItems: [Any]
    let completion: CompletionHandler?

    typealias CompletionHandler = (Bool) -> Void

    init(activityItems: [Any], completion: ShareSheet.CompletionHandler? = nil) {
        self.activityItems = activityItems
        self.completion = completion
    }

    var body: some View {
        ShareSheetWrapper(activityItems: activityItems, completion: completion)
            .ignoresSafeArea(.all, edges: .bottom)
    }
}

private struct ShareSheetWrapper: UIViewControllerRepresentable {
    let activityItems: [Any]
    let completion: ShareSheet.CompletionHandler?

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        // Customize the controller here
        return controller
    }

    func updateUIViewController(_ activityViewController: UIActivityViewController, context: Context) {
        if let completion {
            activityViewController.completionWithItemsHandler = { activityType, success, returnedItems, error in
                completion(success)
            }
        }
    }
}
