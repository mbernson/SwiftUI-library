//
//  QRCodeImage.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 04/07/2023.
//

import SwiftUI

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
        ImageView(uiImage: generateQRCode(from: data))
            .aspectRatio(contentMode: .fit)

        // Image(uiImage: generateQRCode(from: data) ?? UIImage())
        //     .resizable()
        //     .scaledToFit()
    }

    private func generateQRCode(from data: Data?) -> UIImage? {
        guard let data else { return nil }
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")

        let scale: CGFloat = 10
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        let qrImage = qrFilter.outputImage?.transformed(by: transform)

        let uiImage = qrImage.flatMap(UIImage.init)
        return uiImage?.withRenderingMode(.alwaysOriginal)
    }
}

private struct ImageView: UIViewRepresentable {
    let uiImage: UIImage?

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView(image: uiImage)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {}
}

struct QRCodeImage_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeImage(url: URL(string: "https://q42.nl/")!)
    }
}
