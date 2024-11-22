//
//  CameraView.swift
//
//  Created by Mathijs Bernson on 24/05/2023.
//  Copyright © 2023 Q42. All rights reserved.
//

import SwiftUI
import UIKit

/// A view that lets the user take a picture using the camera
struct CameraView: UIViewControllerRepresentable {
    typealias PhotoPickedHandler = (UIImage) -> Void
    typealias DismissHandler = () -> Void

    let cameraDevice: UIImagePickerController.CameraDevice
    let photoPicked: PhotoPickedHandler
    let dismiss: DismissHandler

    init(
        cameraDevice: UIImagePickerController.CameraDevice = .rear,
        photoPicked: @escaping PhotoPickedHandler,
        dismiss: @escaping DismissHandler
    ) {
        self.cameraDevice = cameraDevice
        self.photoPicked = photoPicked
        self.dismiss = dismiss
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.cameraCaptureMode = .photo
        controller.delegate = context.coordinator
        controller.cameraDevice = cameraDevice
        return controller
    }

    func updateUIViewController(_ controller: UIImagePickerController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(photoPickedHandler: photoPicked, dismissHandler: dismiss)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let photoPickedHandler: PhotoPickedHandler
        let dismissHandler: DismissHandler

        init(
            photoPickedHandler: @escaping PhotoPickedHandler,
            dismissHandler: @escaping DismissHandler
        ) {
            self.photoPickedHandler = photoPickedHandler
            self.dismissHandler = dismissHandler
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                photoPickedHandler(image)
            } else {
                assertionFailure("Didn't find the expected image in the info dictionary")
                dismissHandler()
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismissHandler()
        }
    }
}
