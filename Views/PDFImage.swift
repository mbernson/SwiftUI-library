//
//  PDFImage.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 28/02/2024.
//

import SwiftUI

struct PDFImage: View {
    let url: URL?
    let backgroundColor: UIColor

    init(url: URL?, backgroundColor: UIColor = .white) {
        self.url = url
        self.backgroundColor = backgroundColor
    }

    var image: Image {
        Image(uiImage: drawPDFfromURL(url: url) ?? UIImage())
    }

    // Thanks to Hacking with Swift.
    // https://www.hackingwithswift.com/example-code/core-graphics/how-to-render-a-pdf-to-an-image
    func drawPDFfromURL(url: URL?) -> UIImage? {
        guard let url, let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }

        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            backgroundColor.set()
            ctx.fill(pageRect)

            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

            ctx.cgContext.drawPDFPage(page)
        }

        return img
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

#Preview {
    PDFImage(url: Bundle.main.url(forResource: "sample", withExtension: "pdf"))
        .resizable()
        .scaledToFit()
        .border(.black)
        .padding()
}
