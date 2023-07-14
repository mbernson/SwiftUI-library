//
//  QRCodeImage.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 04/07/2023.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

/// A view that renders the given data as a QR code.
/// It behaves just like a SwiftUI `Image`, including the `resizable()` and `scaledToFit()` methods.
///
/// The following example shows how to create a QR code from a URL and scale it to fit within its container:
///
///     QRCodeImage(url: URL(string: "https://q42.nl/")!)
///         .resizable()
///         .scaledToFit()
struct QRCodeImage: View {
    let data: Data?

    init(url: URL) {
        data = url.absoluteString.data(using: .utf8)
    }

    init(string: String) {
        data = string.data(using: .utf8)
    }

    init(data: Data) {
        self.data = data
    }

    var image: Image {
        Image(uiImage: generateQRCode(from: data) ?? UIImage())
            .interpolation(.none)
    }

    private func generateQRCode(from data: Data?) -> UIImage? {
        guard let data else { return nil }
        let filter = CIFilter.qrCodeGenerator()
        filter.message = data

        let context = CIContext()

        return filter.outputImage
            .flatMap { context.createCGImage($0, from: $0.extent) }
            .map { UIImage(cgImage: $0) }
    }

    var body: some View {
        image
    }

    func resizable(capInsets: EdgeInsets = EdgeInsets(), resizingMode: Image.ResizingMode = .stretch) -> Image {
        image.resizable(capInsets: capInsets, resizingMode: resizingMode)
    }

    func scaledToFit() -> some View {
        image.scaledToFit()
    }

    func scaledToFill() -> some View {
        image.scaledToFill()
    }
}

struct QRCodeImage_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeImage(url: URL(string: "https://q42.nl/")!)
            .resizable()
            .scaledToFit()
    }
}
