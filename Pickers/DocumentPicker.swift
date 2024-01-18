//
//  DocumentPicker.swift
//
//  Created by Mathijs Bernson on 27/10/2022.
//

import UniformTypeIdentifiers
import SwiftUI
import UIKit

struct DocumentPicker: UIViewControllerRepresentable {
    typealias DocumentPickedHandler = ([URL]) -> Void
    typealias DismissHandler = () -> Void

    let contentTypes: [UTType]

    let allowsMultipleSelection: Bool
    let documentPicked: DocumentPickedHandler
    let dismiss: DismissHandler

    init(
        contentTypes: [UTType],
        allowsMultipleSelection: Bool,
        documentPicked: @escaping DocumentPicker.DocumentPickedHandler,
        dismiss: DocumentPicker.DismissHandler? = nil
    ) {
        self.contentTypes = contentTypes
        self.allowsMultipleSelection = allowsMultipleSelection
        self.documentPicked = documentPicked
        self.dismiss = dismiss ?? {}
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: contentTypes, asCopy: true)
        controller.allowsMultipleSelection = allowsMultipleSelection
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        //
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(documentPicked: documentPicked, dismiss: dismiss)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let documentPicked: DocumentPickedHandler
        let dismiss: DismissHandler

        init(documentPicked: @escaping DocumentPicker.DocumentPickedHandler, dismiss: @escaping DocumentPicker.DismissHandler) {
            self.documentPicked = documentPicked
            self.dismiss = dismiss
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            documentPicked(urls)
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            dismiss()
        }
    }
}
