//
//  PDFViewer.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 28/02/2024.
//

import SwiftUI
import PDFKit

struct PDFViewer: UIViewRepresentable {
    let url: URL?

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        let document = url.flatMap(PDFDocument.init)
        pdfView.document = document
    }
}

#Preview("PDF viewer") {
    PDFViewer(url: Bundle.main.url(forResource: "sample", withExtension: "pdf"))
        .ignoresSafeArea()
}
