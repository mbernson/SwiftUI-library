//
//  ShareSheet.swift
//
//  Created by Mathijs Bernson on 10/02/2023.
//

import SwiftUI
import UIKit

struct ShareSheet: View {
    let activityItems: [Any]

    var body: some View {
        ShareSheetWrapper(activityItems: activityItems)
            .ignoresSafeArea(.all, edges: .bottom)
    }
}

private struct ShareSheetWrapper: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        // Customize the controller here
        return controller
    }

    func updateUIViewController(_ acvitityViewController: UIActivityViewController, context: Context) {
        //
    }
}
