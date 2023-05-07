//
//  PhotoPicker.swift
//
//  Created by Mathijs Bernson on 05/10/2022.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    typealias PhotoPickedHandler = ([NSItemProvider]) -> Void
    typealias DismissHandler = () -> Void

    let filter: PHPickerFilter?
    let selectionLimit: Int
    let preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode

    let photoPicked: PhotoPickedHandler
    let dismiss: DismissHandler

    init(
        filter: PHPickerFilter? = nil,
        selectionLimit: Int = 0,
        preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode = .compatible,
        photoPicked: @escaping PhotoPicker.PhotoPickedHandler,
        dismiss: PhotoPicker.DismissHandler? = nil
    ) {
        self.filter = filter
        self.selectionLimit = selectionLimit
        self.preferredAssetRepresentationMode = preferredAssetRepresentationMode
        self.photoPicked = photoPicked
        self.dismiss = dismiss ?? {}
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = filter
        configuration.selectionLimit = selectionLimit
        configuration.preferredAssetRepresentationMode = preferredAssetRepresentationMode

        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        //
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPickedHandler: photoPicked, dismissHandler: dismiss)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let photoPickedHandler: PhotoPickedHandler
        let dismissHandler: DismissHandler

        init(photoPickedHandler: @escaping PhotoPicker.PhotoPickedHandler, dismissHandler: @escaping PhotoPicker.DismissHandler) {
            self.photoPickedHandler = photoPickedHandler
            self.dismissHandler = dismissHandler
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if !results.isEmpty {
                photoPickedHandler(results.map(\.itemProvider))
            } else {
                dismissHandler()
            }
        }

    }
}
