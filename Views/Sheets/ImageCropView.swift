//
//  ImageCropView.swift
//
//  Created by Mathijs Bernson on 01/10/2022.
//

#if canImport(RSKImageCropper)
import SwiftUI
import UIKit
import RSKImageCropper

/// A view that lets the user crop an image.
/// Uses the [RSKImageCropper](https://github.com/ruslanskorb/RSKImageCropper) library
struct ImageCropView: UIViewControllerRepresentable {
    typealias ImageCropHandler = (UIImage) -> Void
    typealias DismissHandler = () -> Void

    let image: UIImage
    let cropMode: RSKImageCropMode
    @Binding var zoomRect: CGRect?
    let crop: ImageCropHandler
    let dismiss: DismissHandler

    func makeUIViewController(context: Context) -> RSKImageCropViewController {
        let controller = RSKImageCropViewController(image: image, cropMode: cropMode)
        controller.delegate = context.coordinator

        controller.maskLayerLineWidth = 1.0
        controller.maskLayerStrokeColor = .white

        return controller
    }

    func updateUIViewController(_ controller: RSKImageCropViewController, context: Context) {
        if let zoomRect {
            controller.zoom(to: zoomRect, animated: !context.transaction.disablesAnimations)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(cropHandler: crop, dismissHandler: dismiss)
    }

    class Coordinator: NSObject, RSKImageCropViewControllerDelegate {
        let cropHandler: ImageCropHandler
        let dismissHandler: DismissHandler

        init(cropHandler: @escaping ImageCropHandler, dismissHandler: @escaping DismissHandler) {
            self.cropHandler = cropHandler
            self.dismissHandler = dismissHandler
        }

        func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
            dismissHandler()
        }

        func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
            cropHandler(croppedImage)
        }
    }
}
#endif
