//
//  QRCodeImage.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 04/07/2023.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

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

    var body: some View {
        Image(uiImage: generateQRCode(from: data) ?? UIImage())
            .resizable()
            .interpolation(.none)
            .scaledToFit()
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
}

struct QRCodeImage_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeImage(url: URL(string: "https://q42.nl/")!)
    }
}
