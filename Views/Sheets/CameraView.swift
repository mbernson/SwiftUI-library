//
//  CameraView.swift
//
//  Created by Mathijs Bernson on 24/05/2023.
//  Copyright © 2023 Q42. All rights reserved.
//

import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    typealias PhotoPickedHandler = (UIImage) -> Void
    typealias DismissHandler = () -> Void

    let photoPicked: PhotoPickedHandler
    let dismiss: DismissHandler

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.cameraCaptureMode = .photo
        controller.delegate = context.coordinator
        controller.cameraDevice = .front
        return controller
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(photoPickedHandler: photoPicked, dismissHandler: dismiss)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let photoPickedHandler: PhotoPickedHandler
        let dismissHandler: DismissHandler

        init(photoPickedHandler: @escaping CameraView.PhotoPickedHandler, dismissHandler: @escaping CameraView.DismissHandler) {
            self.photoPickedHandler = photoPickedHandler
            self.dismissHandler = dismissHandler
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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
