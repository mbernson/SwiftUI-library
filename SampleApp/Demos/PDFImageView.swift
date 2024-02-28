//
//  PDFImageView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 28/02/2024.
//

import SwiftUI

struct PDFImageView: View {
    var body: some View {
        PDFImage(url: Bundle.main.url(forResource: "sample", withExtension: "pdf"))
            .resizable()
            .scaledToFit()
            .border(.black)
            .padding()
            .navigationTitle("PDF image")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PDFImageView()
}
