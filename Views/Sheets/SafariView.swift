//
//  SafariView.swift
//
//  Created by Mathijs Bernson on 01/11/2022.
//

import SwiftUI
import SafariServices

struct SafariView: View {
    let url: URL
    let configuration: SFSafariViewController.Configuration?

    init(url: URL, configuration: SFSafariViewController.Configuration? = nil) {
        self.url = url
        self.configuration = configuration
    }

    var body: some View {
        SafariViewWrapper(url: url, configuration: configuration)
            .ignoresSafeArea(.all, edges: .bottom)
    }
}

private struct SafariViewWrapper: UIViewControllerRepresentable {
    let url: URL
    let configuration: SFSafariViewController.Configuration?

    func makeUIViewController(context: Context) -> SFSafariViewController {
        if let configuration {
            return SFSafariViewController(url: url, configuration: configuration)
        } else {
            return SFSafariViewController(url: url)
        }
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        //
    }
}
